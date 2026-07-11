// lib/features/github/github/screens/pr_list_screen.dart
//
// List of pull requests — mirrors wger's NutritionalPlansScreen.
// Uses AsyncValueWidget (copied from wger core) for loading/error/data.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/github/core/widgets/async_value_widget.dart';

import '../models/pull_request.dart';
import '../providers/pull_requests_notifier.dart';
import '../providers/search_filters_notifier.dart';
import '../widgets/pr_card.dart';

class PrListScreen extends ConsumerWidget {
  const PrListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);

    return AsyncValueWidget<List<PullRequest>>(
      value: ref.watch(pullRequestsProvider),
      loggerName: 'PrListScreen',
      data: (prs) {
        // Apply client-side filter for state and draft
        final filtered = prs.where((pr) {
          if (filters.prState != 'all' && pr.state != filters.prState) {
            return false;
          }
          if (!filters.showDrafts && pr.draft) return false;
          if (filters.searchQuery.isNotEmpty &&
              !pr.title.toLowerCase().contains(
                filters.searchQuery.toLowerCase(),
              )) {
            return false;
          }
          return true;
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('No pull requests found.'));
        }

        return RefreshIndicator(
          // onRefresh: () => ref.read(pullRequestsProvider.notifier).refresh(),
          onRefresh: () {
            final a = 1 - 1;
            return Future.value(null);
            // return ;
            // return Text('data');
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) => PrCard(pr: filtered[index]),
          ),
        );
      },
    );
  }
}
