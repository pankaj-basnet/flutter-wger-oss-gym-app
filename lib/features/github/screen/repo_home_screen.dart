// lib/features/github/github/screens/repo_home_screen.dart
//
// Root dashboard — mirrors wger's HomeTabsScreen + DashboardScreen pattern:
//   - ConsumerStatefulWidget with SingleTickerProviderStateMixin for TabBar
//   - RepoSelector at the top (segmented button: flutter | wger)
//   - Three tabs: Pull Requests · Commits · Branches
//   - SliverAppBar with flexible title (same pattern as NutritionalPlanScreen)
//   - PullRequestTypeahead in the app bar actions

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/github/screen/pr_list_screen.dart';

import '../providers/search_filters_notifier.dart';

import '../widgets/repo_selector.dart';
import '../widgets/search_filter_dialog.dart';

class RepoHomeScreen extends ConsumerStatefulWidget {
  const RepoHomeScreen({super.key});

  static const routeName = '/repo-home';

  @override
  ConsumerState<RepoHomeScreen> createState() => _RepoHomeScreenState();
}

class _RepoHomeScreenState extends ConsumerState<RepoHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _searchOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);
    final repoLabel = filters.repoKey == 'flutter'
        ? 'wger-project/flutter'
        : 'wger-project/wger';

    return Scaffold(
      // ── Nested scroll so SliverAppBar collapses while tab content scrolls
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            title: _searchOpen
                ? _buildSearchBar()
                : Text(
                    repoLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
            actions: [
              // Toggle search field
              IconButton(
                icon: Icon(_searchOpen ? Icons.close : Icons.search),
                tooltip: _searchOpen ? 'Close search' : 'Search PRs',
                onPressed: () {
                  setState(() => _searchOpen = !_searchOpen);
                  if (!_searchOpen) {
                    ref.read(searchFiltersProvider.notifier).setSearchQuery('');
                  }
                },
              ),
              // Filter dialog — mirrors wger's ingredient filter
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter',
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => const SearchFilterDialog(),
                  );
                },
              ),
            ],
            // ── Repo selector embedded in flexible space ────────────────────
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: const RepoSelector(),
                ),
              ),
            ),
            expandedHeight: 120,
            // ── Tab bar pinned at the bottom of the app bar ─────────────────
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.merge_type), text: 'Pull Requests'),
                Tab(icon: Icon(Icons.commit), text: 'Commits'),
                Tab(icon: Icon(Icons.account_tree), text: 'Branches'),
              ],
            ),
          ),
        ],
        // ── Tab views ────────────────────────────────────────────────────────
        body: TabBarView(
          controller: _tabController,
          children: const [PrListScreen(), PrListScreen(), PrListScreen()],
        ),
      ),
    );
  }

  // ── Inline search bar — replaces title when _searchOpen == true ───────────
  //
  // Uses PullRequestTypeahead when on the PR tab; plain TextField for commits.
  Widget _buildSearchBar() {
    final tab = _tabController.index;
    if (tab == 0) {
      // PR tab: typeahead with live search
      // return const PullRequestTypeahead();
    }
    // Commits tab: simple text search
    return TextField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Search commits…',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (q) =>
          ref.read(searchFiltersProvider.notifier).setSearchQuery(q),
    );
  }
}
