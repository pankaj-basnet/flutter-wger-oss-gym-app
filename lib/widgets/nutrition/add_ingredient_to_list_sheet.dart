import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/providers/ingredient_notifier.dart';
import 'package:wger/providers/ingredient_repository.dart';
import 'package:wger/screens/ingredient_lists_screen.dart';
import 'package:wger/theme/theme.dart';

class AddIngredientToListSheet extends ConsumerWidget {
  const AddIngredientToListSheet({super.key, required this.ingredientId});
  final int ingredientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipAsync = ref.watch(ingredientListMembershipProvider(ingredientId));
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(16),
      child: membershipAsync.when(
        data: (entries) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Iterate through list entries
            ...entries.map(
              (entry) => CheckboxListTile(
                tileColor: wgerPrimaryColorLight,
                title: Text(
                  entry.name,
                  style: TextStyle(
                    fontWeight: entry.isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                value: entry.isSelected,
                selectedTileColor: wgerPrimaryColor.withValues(alpha: 0.8),
                onChanged: (_) => ref
                    .read(ingredientRepositoryProvider)
                    .toggleIngredientInList(entry.id, ingredientId),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IngredientListsScreen(ingredientId: ingredientId),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Manage all lists'),
                style: FilledButton.styleFrom(
                  backgroundColor: wgerPrimaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
