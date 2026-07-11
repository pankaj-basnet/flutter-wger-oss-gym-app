// lib/features/github/github/providers/pull_requests_notifier.dart
//
// Mirrors wger's NutritionNotifier exactly:
//   - @Riverpod(keepAlive: true)
//   - StreamNotifier — exposes repo's watchPullRequests() stream
//   - Triggers HTTP fetch in build() so the stream is always fresh
//   - keepAlive: true because PR list is used across multiple screens

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/github/models/github_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/pull_request.dart';

import 'search_filters_notifier.dart';

part 'pull_requests_notifier.g.dart';

@Riverpod(keepAlive: true)
class PullRequestsNotifier extends _$PullRequestsNotifier {
  @override
  Stream<List<PullRequest>> build() {
    ref.keepAlive();

    final repoKey = ref.watch(searchFiltersProvider.select((s) => s.repoKey));

    // Fire-and-forget HTTP fetch — Drift stream delivers results reactively.
    // If the fetch fails, the existing cache continues to serve data.
    // _fetchInBackground(repoKey);
    return Stream.value([
      PullRequest(
        id: 1,
        number: 2,
        title: 'title',
        htmlUrl: 'htmlUrl',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: GithubUser(
          login: 'login',
          avatarUrl: 'avatarUrl',
          htmlUrl: 'htmlUrl',
        ),
      ),
    ]);
    // return ref.read(githubRepositoryProvider).watchPullRequests(repoKey);
  }

  // Future<void> _fetchInBackground(String repoKey) async {
  //   try {
  //     await ref
  //         .read(githubRepositoryProvider)
  //         .fetchAndCachePullRequests(repoKey, state: 'all', perPage: 50);
  //   } catch (_) {
  //     // Swallow — cached data is still streamed
  //   }
  // }

  // /// Force refresh from GitHub API (e.g. pull-to-refresh).
  // Future<void> refresh() async {
  //   final repoKey = ref.read(searchFiltersProvider).repoKey;
  //   await ref
  //       .read(githubRepositoryProvider)
  //       .fetchAndCachePullRequests(repoKey, state: 'all', perPage: 50);
  // }
}
