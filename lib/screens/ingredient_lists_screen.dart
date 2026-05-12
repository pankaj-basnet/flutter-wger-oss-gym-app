import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/models/nutrition/ingredient_list_entry.dart';
import 'package:wger/providers/ingredient_notifier.dart';
import 'package:wger/screens/ingredient_list_detail_screen.dart';
import 'package:wger/theme/theme.dart';
import 'package:wger/widgets/core/progress_indicator.dart';

class IngredientListsScreen extends ConsumerWidget {
  const IngredientListsScreen({super.key, this.ingredientId});

  static const routeName = '/ingredient-lists';

  /// When non-null, checkboxes appear so the user can add/remove
  /// this ingredient across lists (via IngredientDetailScreen ).
  final int? ingredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all lists; pass ingredientId so membership flags are populated.
    final listsAsync = ref.watch(
      allIngredientListsProvider(ingredientId: ingredientId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My ingredient lists'),
      ),
      body: listsAsync.when(
        loading: () => const BoxedProgressIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) => entries.isEmpty
            ? const Center(child: Text('No lists yet. Tap + to create one.'))
            : ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _IngredientListTile(
                    entry: entry,
                    ingredientId: ingredientId,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListDialog(context, ref),
        tooltip: 'New list',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateListDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New list'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'List name'),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    final name = controller.text.trim();
    if (confirmed == true && name.isNotEmpty) {
      await ref.read(ingredientProvider.notifier).createIngredientList(name);
    }
  }
}

class _IngredientListTile extends ConsumerWidget {
  const _IngredientListTile({
    required this.entry,
    required this.ingredientId,
  });

  final IngredientListEntry entry;
  final int? ingredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // When in "from product" mode  (from IngredientDetail screen), show a checkbox.
    // Otherwise show a normal list tile that navigates to the detail screen.
    if (ingredientId != null) {
      return CheckboxListTile(
        title: Text(entry.name),
        subtitle: Text('${entry.ingredientCount} ingredients'),
        value: entry.isSelected,
        onChanged: (_) => _toggle(ref),
        secondary: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          tooltip: 'Open list',
          onPressed: () => _navigateToDetail(context),
        ),
      );
    }

    return ListTile(
      title: Text(entry.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ListCountBadge(
            count: entry.ingredientCount,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete list',
            onPressed: () => _confirmDelete(context, ref),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _navigateToDetail(context),
    );
  }

  void _toggle(WidgetRef ref) {
    if (entry.isSelected) {
      ref.read(ingredientProvider.notifier).removeIngredientFromList(entry.id, ingredientId!);
    } else {
      ref.read(ingredientProvider.notifier).addIngredientToList(entry.id, ingredientId!);
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngredientListDetailScreen(
          listId: entry.id,
          listName: entry.name,
          currentIngredientId: ingredientId,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete list?'), // TODO: i10n
        content: Text('Delete "${entry.name}" and all its items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(ingredientProvider.notifier).deleteIngredientList(entry.id);
    }
  }
}

class _ListCountBadge extends StatelessWidget {
  final int count;

  const _ListCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: wgerPrimaryColorLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: wgerPrimaryColorLight),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: wgerPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
