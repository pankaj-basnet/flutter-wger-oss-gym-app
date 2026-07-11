// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_requests_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PullRequestsNotifier)
final pullRequestsProvider = PullRequestsNotifierProvider._();

final class PullRequestsNotifierProvider
    extends $StreamNotifierProvider<PullRequestsNotifier, List<PullRequest>> {
  PullRequestsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pullRequestsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pullRequestsNotifierHash();

  @$internal
  @override
  PullRequestsNotifier create() => PullRequestsNotifier();
}

String _$pullRequestsNotifierHash() =>
    r'3819afdf864cf63923aba2c7384a3f5c0d55a97f';

abstract class _$PullRequestsNotifier
    extends $StreamNotifier<List<PullRequest>> {
  Stream<List<PullRequest>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PullRequest>>, List<PullRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PullRequest>>, List<PullRequest>>,
              AsyncValue<List<PullRequest>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
