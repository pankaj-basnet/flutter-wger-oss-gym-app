// lib/features/github/github/widgets/search_filter_dialog.dart
//
// Mirrors wger's IngredientFilterDialog.
// showDialog → AlertDialog with filter controls.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_filters_notifier.dart';

class SearchFilterDialog extends ConsumerStatefulWidget {
  const SearchFilterDialog({super.key});

  @override
  ConsumerState<SearchFilterDialog> createState() => _SearchFilterDialogState();
}

class _SearchFilterDialogState extends ConsumerState<SearchFilterDialog> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);

    return AlertDialog(
      title: const Text('Filter Pull Requests'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // State filter
          DropdownButtonFormField<String>(
            value: filters.prState,
            decoration: const InputDecoration(labelText: 'State'),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'open', child: Text('Open')),
              DropdownMenuItem(value: 'closed', child: Text('Closed')),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(searchFiltersProvider.notifier).setPrState(v);
              }
            },
          ),
          const SizedBox(height: 8),
          // Draft toggle
          SwitchListTile(
            title: const Text('Show drafts'),
            value: filters.showDrafts,
            onChanged: (_) {
              ref.read(searchFiltersProvider.notifier).toggleDrafts();
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
