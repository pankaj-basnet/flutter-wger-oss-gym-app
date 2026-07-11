// lib/features/github/github/providers/search_filters_notifier.dart
//
// Mirrors wger's IngredientFiltersNotifier — @freezed state + @riverpod notifier.
// Holds the current UI filter state: which repo is selected, PR state filter, draft toggle.
// Used by RepoSelector, SearchFilterDialog, and the notifiers above to know what to fetch.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filters_notifier.freezed.dart';
part 'search_filters_notifier.g.dart';

@freezed
abstract class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    @Default('flutter') String repoKey, // 'flutter' | 'wger'
    @Default('all') String prState, // 'all' | 'open' | 'closed'
    @Default(false) bool showDrafts,
    @Default('') String searchQuery,
  }) = _SearchFilters;
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void selectRepo(String repoKey) {
    state = state.copyWith(repoKey: repoKey, searchQuery: '');
  }

  void setPrState(String prState) {
    state = state.copyWith(prState: prState);
  }

  void toggleDrafts() {
    state = state.copyWith(showDrafts: !state.showDrafts);
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
  }
}
