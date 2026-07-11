// lib/features/github/github/widgets/repo_selector.dart
//
// SegmentedButton to switch between wger-project/flutter and wger-project/wger.
// Writes to searchFiltersProvider — causes PullRequestsNotifier + BranchesNotifier to rebuild.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_filters_notifier.dart';

class RepoSelector extends ConsumerWidget {
  const RepoSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoKey = ref.watch(searchFiltersProvider.select((s) => s.repoKey));

    return SegmentedButton<String>(
      style: SegmentedButton.styleFrom(
        foregroundColor: Colors.white,
        selectedForegroundColor: Theme.of(context).colorScheme.primary,
        selectedBackgroundColor: Colors.white,
      ),
      segments: const [
        ButtonSegment(
          value: 'flutter',
          label: Text('Flutter'),
          icon: Icon(Icons.phone_android, size: 14),
        ),
        ButtonSegment(
          value: 'wger',
          label: Text('Django'),
          icon: Icon(Icons.storage, size: 14),
        ),
      ],
      selected: {repoKey},
      onSelectionChanged: (selection) {
        ref.read(searchFiltersProvider.notifier).selectRepo(selection.first);
      },
    );
  }
}
