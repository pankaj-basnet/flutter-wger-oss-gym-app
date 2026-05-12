import 'package:drift/drift.dart';
import 'package:wger/database/powersync/tables/ingredient_lists.dart';

class IngredientListItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer().references(IngredientListsTable, #id)();
  IntColumn get ingredientId => integer()(); // References ingredient table ID
  DateTimeColumn get addedAt => dateTime()();
}
