import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/nutrition/ingredient.dart';
import 'package:wger/providers/ingredient_notifier.dart';
import 'package:wger/widgets/core/progress_indicator.dart';

class IngredientListDetailScreen extends ConsumerWidget {
  const IngredientListDetailScreen({
    super.key,
    required this.listId,
    required this.listName,
    this.currentIngredientId,
  });

  static const routeName = '/ingredient-list-detail';

  final int listId;
  final String listName;

  /// When non-null (opened from a product), an "Add this ingredient" button
  /// appears in the app bar if the ingredient is not yet in this list.
  final int? currentIngredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all ingredients in this list
    final ingredientsAsync = ref.watch(ingredientsInListProvider(listId));

    // Watch membership to know if currentIngredientId is already in this list.
    // Only needed when we have a product context.
    final membershipAsync = currentIngredientId != null
        ? ref.watch(ingredientListMembershipProvider(currentIngredientId!))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(listName),
        actions: [
          // Show "Add this ingredient" button only when in product context (from IngredientDetail screen)
          if (currentIngredientId != null)
            _AddIngredientAction(
              listId: listId,
              ingredientId: currentIngredientId!,
              membershipAsync: membershipAsync!,
            ),
        ],
      ),

      body: ingredientsAsync.when(
        loading: () => const BoxedProgressIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (ingredients) => ingredients.isEmpty
            ? const Center(child: Text('This list is empty.'))
            : ListView.separated(
                itemCount: ingredients.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  return _IngredientInListTile(
                    ingredient: ingredient,
                    listId: listId,
                  );
                },
              ),
      ),
    );
  }
}

// App bar action: "Add / Already added" button
class _AddIngredientAction extends ConsumerWidget {
  const _AddIngredientAction({
    required this.listId,
    required this.ingredientId,
    required this.membershipAsync,
  });

  final int listId;
  final int ingredientId;
  final AsyncValue<List<dynamic>> membershipAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return membershipAsync.when(
      loading: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (entries) {
        // Find the entry for THIS list
        final alreadyIn = entries.any(
          (e) => e.id == listId && e.isSelected,
        );

        if (alreadyIn) {
          // Show a filled check icon — tapping it removes the ingredient
          return IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.check_circle),
            tooltip: 'Remove from this list',
            onPressed: () async {
              await ref
                  .read(ingredientProvider.notifier)
                  .removeIngredientFromList(listId, ingredientId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from list')),
                );
              }
            },
          );
        }

        // Show "Add" button
        return TextButton.icon(
          icon: const Icon(
            Icons.add,
            color: Colors.grey,
          ),
          label: const Text('Add to list'),
          onPressed: () async {
            await ref.read(ingredientProvider.notifier).addIngredientToList(listId, ingredientId);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to list')),
              );
            }
          },
        );
      },
    );
  }
}

// Single ingredient row (with remove button)

class _IngredientInListTile extends ConsumerWidget {
  const _IngredientInListTile({
    required this.ingredient,
    required this.listId,
  });

  final Ingredient ingredient;
  final int listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = AppLocalizations.of(context);

    return ListTile(
      title: Text(ingredient.name),
      subtitle: ingredient.nutriscore != null
          ? Text('${i18n.nutriscoreValue} ${ingredient.nutriscore!.name.toUpperCase()}')
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        tooltip: 'Remove from list',
        onPressed: () => _confirmRemove(context, ref),
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${ingredient.name}?'),
        content: const Text('Remove this ingredient from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(ingredientProvider.notifier).removeIngredientFromList(listId, ingredient.id!);
    }
  }
}
