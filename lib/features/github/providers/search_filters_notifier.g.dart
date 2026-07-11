// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFiltersNotifier)
final searchFiltersProvider = SearchFiltersNotifierProvider._();

final class SearchFiltersNotifierProvider
    extends $NotifierProvider<SearchFiltersNotifier, SearchFilters> {
  SearchFiltersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFiltersNotifierHash();

  @$internal
  @override
  SearchFiltersNotifier create() => SearchFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilters>(value),
    );
  }
}

String _$searchFiltersNotifierHash() =>
    r'8f5e9c8e4f55b1cf2a939fa1d03049fb3ad808d4';

abstract class _$SearchFiltersNotifier extends $Notifier<SearchFilters> {
  SearchFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchFilters, SearchFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilters, SearchFilters>,
              SearchFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
