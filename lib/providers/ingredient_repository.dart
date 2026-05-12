/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c)  2026 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/core/search_options.dart';
import 'package:wger/models/nutrition/ingredient.dart';
import 'package:wger/models/nutrition/ingredient_list_entry.dart';
import 'package:wger/models/nutrition/ingredient_weight_unit.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/wger_base.dart';

import '../database/powersync/database.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  final base = ref.read(wgerBaseProvider);
  final db = ref.read(driftPowerSyncDatabase);
  return IngredientRepository(base, db);
});

/// Data access for ingredient lookups and searches.
///
/// Exposes both transport paths ([searchIngredientServer], [searchIngredientLocal])
/// as pure data-access primitives. Connectivity-aware routing between them lives
/// on [IngredientNotifier.searchIngredient] (lib/providers/ingredient_notifier.dart),
/// where `ref` is at hand.
class IngredientRepository {
  final _logger = Logger('IngredientRepository');
  final WgerBaseProvider _base;
  final DriftPowersyncDatabase _db;

  static const ingredientInfoPath = 'ingredientinfo';

  IngredientRepository(this._base, this._db);

  /// Watches a single ingredient by [id] with its `image` and `weightUnits`
  /// fields fully hydrated. Emits `null` if no ingredient with that id exists,
  /// and re-emits whenever the ingredient row, its image, or any of its
  /// weight units change.
  Stream<Ingredient?> watchById(int id) {
    _logger.finer('Watching ingredient $id');
    final query = _baseJoinedQuery()..where(_db.ingredientTable.id.equals(id));
    return query.watch().map((rows) {
      final hydrated = _hydrate(rows);
      return hydrated.isEmpty ? null : hydrated.first;
    });
  }

  /// Watches all locally synced ingredients.
  ///
  /// Only ingredients that are used in a nutritional plan or log are
  /// synced to the device for offline storage in the Drift database.
  Stream<List<Ingredient>> watchAllDrift() {
    _logger.finer('Watching all synced ingredients');
    final query = _baseJoinedQuery()..orderBy([OrderingTerm(expression: _db.ingredientTable.name)]);
    return query.watch().map((rows) {
      return _hydrate(rows);
    });
  }

  /// Read a single ingredient by [id] once from the DB
  Future<Ingredient?> getById(int id) async {
    _logger.finer('Reading ingredient $id');
    return watchById(id).first;
  }

  /// Substring-search by name against the locally-synced ingredients,
  /// with optional diet-flag and Nutri-Score filters. Used for offline-mode
  /// ingredient pickers
  ///
  /// Hydrates `image` and `weightUnits` on the returned rows so the
  /// result is shape-compatible with the REST search.
  Future<List<Ingredient>> searchIngredientLocal(
    String term, {
    bool isVegan = false,
    bool isVegetarian = false,
    NutriScore? nutriscoreMax,
    int limit = 100,
  }) async {
    _logger.finer('Local ingredient search: "$term"');
    final query = _baseJoinedQuery()
      ..where(_db.ingredientTable.name.lower().like('%${term.toLowerCase()}%'));

    if (isVegan) {
      query.where(_db.ingredientTable.isVegan.equals(true));
    }
    if (isVegetarian) {
      query.where(_db.ingredientTable.isVegetarian.equals(true));
    }
    if (nutriscoreMax != null) {
      query.where(_db.ingredientTable.nutriscore.isSmallerOrEqualValue(nutriscoreMax.name));
    }
    query
      ..orderBy([OrderingTerm(expression: _db.ingredientTable.name)])
      ..limit(limit);

    return _hydrate(await query.get());
  }

  /// Searches for ingredients via the wger REST API.
  Future<List<Ingredient>> searchIngredientServer(
    String name, {
    String languageCode = 'en',
    SearchLanguage searchLanguage = SearchLanguage.current,
    bool isVegan = false,
    bool isVegetarian = false,
    NutriScore? nutriscoreMax,
  }) async {
    if (name.length <= 1) {
      return [];
    }
    final List<String> languages = [];

    switch (searchLanguage) {
      case SearchLanguage.current:
        languages.add(languageCode);
      case SearchLanguage.currentAndEnglish:
        languages.add(languageCode);
        if (languageCode != LANGUAGE_SHORT_ENGLISH) {
          languages.add(LANGUAGE_SHORT_ENGLISH);
        }
      case SearchLanguage.all:
        // Don't add any language code to search in all languages
        break;
    }

    final query = {
      'name__search': name,
      'limit': API_RESULTS_PAGE_SIZE,
    };
    if (languages.isNotEmpty) {
      query['language__code'] = languages.join(',');
    }
    if (isVegan) {
      query['is_vegan'] = 'true';
    }
    if (isVegetarian) {
      query['is_vegetarian'] = 'true';
    }
    if (nutriscoreMax != null) {
      query['nutriscore__lte'] = nutriscoreMax.name;
    }

    _logger.info('Searching ingredients from server');
    final response = await _base.fetch(
      _base.makeUrl(ingredientInfoPath, query: query),
      timeout: const Duration(seconds: 20),
    );

    return (response['results'] as List)
        .map((data) => Ingredient.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  /// Looks up an ingredient by its product barcode via the REST API.
  /// Returns `null` if no matching product is found.
  Future<Ingredient?> searchIngredientByBarcode(String barcode) async {
    if (barcode.isEmpty) {
      return null;
    }
    final data = await _base.fetch(
      _base.makeUrl(ingredientInfoPath, query: {'code': barcode}),
    );
    if (data['count'] == 0) {
      return null;
    }
    return Ingredient.fromJson(data['results'][0]);
  }

  Stream<List<IngredientListEntry>> watchListMembershipForIngredient(int ingredientId) {
    final query = _db.select(_db.ingredientListsTable);

    return query.watch().asyncExpand((lists) {
      if (lists.isEmpty) return Stream.value([]);

      // For each list, check if the ingredient is present
      return _db.select(_db.ingredientListItemsTable).watch().map((allItems) {
        return lists.map((list) {
          final isSelected = allItems.any(
            (item) => item.listId == list.id && item.ingredientId == ingredientId,
          );
          return IngredientListEntry(
            id: list.id,
            name: list.name,
            isSelected: isSelected,
          );
        }).toList();
      });
    });
  }

  Future<void> toggleIngredientInList(int listId, int ingredientId) async {
    final query = _db.delete(_db.ingredientListItemsTable)
      ..where((t) => t.listId.equals(listId) & t.ingredientId.equals(ingredientId));

    final deletedCount = await query.go();

    if (deletedCount == 0) {
      // If nothing was deleted, it wasn't there, so we add it
      await _db
          .into(_db.ingredientListItemsTable)
          .insert(
            IngredientListItemsTableCompanion.insert(
              listId: listId,
              ingredientId: ingredientId,
              addedAt: DateTime.now(),
            ),
          );
    }
  }

  /// Watches all user-created ingredient lists.
  /// Emits a new list whenever any list is added, renamed, or deleted.
  Stream<List<IngredientListEntry>> watchAllIngredientLists() {
    return _db
        .select(_db.ingredientListsTable)
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => IngredientListEntry(
                  id: row.id,
                  name: row.name,
                  isSelected: false,
                  ingredientCount: 0,
                ),
              )
              .toList(),
        );
  }

  /// Watches all user-created ingredient lists, annotated with:
  /// - [ingredientCount]: total ingredients in that list
  /// - [isSelected]: whether [ingredientId] is already in that list
  ///   (pass null when there is no ingredient context)
  Stream<List<IngredientListEntry>> watchAllListsWithMembership({
    int? ingredientId,
  }) {
    final listStream = _db.select(_db.ingredientListsTable).watch();
    final itemStream = _db.select(_db.ingredientListItemsTable).watch();

    return listStream.asyncExpand((lists) {
      if (lists.isEmpty) return Stream.value([]);
      return itemStream.map((allItems) {
        return lists.map((list) {
          final itemsForList = allItems.where((i) => i.listId == list.id).toList();
          final isSelected =
              ingredientId != null && itemsForList.any((i) => i.ingredientId == ingredientId);
          return IngredientListEntry(
            id: list.id,
            name: list.name,
            isSelected: isSelected,
            ingredientCount: itemsForList.length,
          );
        }).toList();
      });
    });
  }

  /// Watches all ingredients belonging to [listId], fully hydrated.
  Stream<List<Ingredient>> watchIngredientsInList(int listId) {
    // Get the ids of ingredients in the list, then join with ingredient table
    final itemQuery = _db.select(_db.ingredientListItemsTable)
      ..where((t) => t.listId.equals(listId));

    return itemQuery.watch().asyncExpand((items) {
      if (items.isEmpty) return Stream.value([]);
      final ids = items.map((i) => i.ingredientId).toList();
      final query = _baseJoinedQuery()..where(_db.ingredientTable.id.isIn(ids));
      return query.watch().map(_hydrate);
    });
  }

  /// Creates a new user-created ingredient list with [name].
  /// Returns the id of the newly created list.
  Future<int> createIngredientList(String name) async {
    _logger.info('Creating ingredient list: $name');
    final id = await _db
        .into(_db.ingredientListsTable)
        .insert(
          IngredientListsTableCompanion.insert(name: name, createdAt: DateTime.now()),
        );
    return id;
  }

  /// Deletes the list with [listId] and all its ingredient memberships.
  Future<void> deleteIngredientList(int listId) async {
    _logger.info('Deleting ingredient list id=$listId');
    await _db.transaction(() async {
      // Delete items first (foreign key child)
      await (_db.delete(_db.ingredientListItemsTable)..where((t) => t.listId.equals(listId))).go();
      // Delete the list itself
      await (_db.delete(_db.ingredientListsTable)..where((t) => t.id.equals(listId))).go();
    });
  }

  /// Adds [ingredientId] to [listId] if it is not already present.
  /// Does nothing (idempotent) if it is already there.
  Future<void> addIngredientToList(int listId, int ingredientId) async {
    _logger.info('Adding ingredient $ingredientId to list $listId');
    await _db
        .into(_db.ingredientListItemsTable)
        .insertOnConflictUpdate(
          IngredientListItemsTableCompanion.insert(
            listId: listId,
            ingredientId: ingredientId,
            addedAt: DateTime.now(),
          ),
        );
  }

  /// Removes [ingredientId] from [listId].
  Future<void> removeIngredientFromList(int listId, int ingredientId) async {
    _logger.info('Removing ingredient $ingredientId from list $listId');
    await (_db.delete(_db.ingredientListItemsTable)..where(
          (t) => t.listId.equals(listId) & t.ingredientId.equals(ingredientId),
        ))
        .go();
  }

  /// Builds the standard joined query used by every ingredient lookup
  JoinedSelectStatement<HasResultSet, dynamic> _baseJoinedQuery() {
    return _db.select(_db.ingredientTable).join([
      leftOuterJoin(
        _db.ingredientImageTable,
        _db.ingredientImageTable.ingredientId.equalsExp(_db.ingredientTable.id),
      ),
      leftOuterJoin(
        _db.ingredientWeightUnitTable,
        _db.ingredientWeightUnitTable.ingredientId.equalsExp(_db.ingredientTable.id),
      ),
    ]);
  }

  /// Collapses cross-joined rows into a deduped list of hydrated ingredients
  List<Ingredient> _hydrate(Iterable<TypedResult> rows) {
    final Map<int, Ingredient> ingredients = {};
    final Map<int, List<IngredientWeightUnit>> weightUnits = {};

    for (final row in rows) {
      final ingredient = row.readTable(_db.ingredientTable);
      final image = row.readTableOrNull(_db.ingredientImageTable);
      final weightUnit = row.readTableOrNull(_db.ingredientWeightUnitTable);

      final entry = ingredients.putIfAbsent(ingredient.id, () => ingredient);
      if (image != null) {
        entry.image = image;
      }
      if (weightUnit != null) {
        final list = weightUnits.putIfAbsent(ingredient.id, () => []);
        if (!list.any((w) => w.id == weightUnit.id)) {
          list.add(weightUnit);
        }
      }
    }

    for (final entry in ingredients.values) {
      entry.weightUnits = weightUnits[entry.id] ?? const [];
    }

    return ingredients.values.toList();
  }
}
