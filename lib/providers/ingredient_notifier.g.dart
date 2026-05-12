// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientNotifier)
final ingredientProvider = IngredientNotifierProvider._();

final class IngredientNotifierProvider
    extends $StreamNotifierProvider<IngredientNotifier, List<Ingredient>> {
  IngredientNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientNotifierHash();

  @$internal
  @override
  IngredientNotifier create() => IngredientNotifier();
}

<<<<<<< Updated upstream
String _$ingredientNotifierHash() => r'40e9fa3376a25289b04a86f9303e20de77cab1d8';
=======
String _$ingredientNotifierHash() => r'619f37f447e617918f307fd8a8344d5480a1f651';
>>>>>>> Stashed changes

abstract class _$IngredientNotifier extends $StreamNotifier<List<Ingredient>> {
  Stream<List<Ingredient>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Ingredient>>, List<Ingredient>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Ingredient>>, List<Ingredient>>,
              AsyncValue<List<Ingredient>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ingredientListMembership)
final ingredientListMembershipProvider = IngredientListMembershipFamily._();

final class IngredientListMembershipProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientListEntry>>,
          List<IngredientListEntry>,
          Stream<List<IngredientListEntry>>
        >
    with $FutureModifier<List<IngredientListEntry>>, $StreamProvider<List<IngredientListEntry>> {
  IngredientListMembershipProvider._({
    required IngredientListMembershipFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ingredientListMembershipProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientListMembershipHash();

  @override
  String toString() {
    return r'ingredientListMembershipProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<IngredientListEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<IngredientListEntry>> create(Ref ref) {
    final argument = this.argument as int;
    return ingredientListMembership(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientListMembershipProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientListMembershipHash() => r'273546177ed1e3edb86591e43f735baf2c0a95e0';

final class IngredientListMembershipFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<IngredientListEntry>>, int> {
  IngredientListMembershipFamily._()
    : super(
        retry: null,
        name: r'ingredientListMembershipProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IngredientListMembershipProvider call(int ingredientId) =>
      IngredientListMembershipProvider._(argument: ingredientId, from: this);

  @override
  String toString() => r'ingredientListMembershipProvider';
}

/// Watches all user ingredient lists.
/// When [ingredientId] is provided (non-null), each entry's [isSelected]
/// and [ingredientCount] fields are populated.
/// When null, [isSelected] is always false (use on a generic list manager).

@ProviderFor(allIngredientLists)
final allIngredientListsProvider = AllIngredientListsFamily._();

/// Watches all user ingredient lists.
/// When [ingredientId] is provided (non-null), each entry's [isSelected]
/// and [ingredientCount] fields are populated.
/// When null, [isSelected] is always false (use on a generic list manager).

final class AllIngredientListsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientListEntry>>,
          List<IngredientListEntry>,
          Stream<List<IngredientListEntry>>
        >
    with $FutureModifier<List<IngredientListEntry>>, $StreamProvider<List<IngredientListEntry>> {
  /// Watches all user ingredient lists.
  /// When [ingredientId] is provided (non-null), each entry's [isSelected]
  /// and [ingredientCount] fields are populated.
  /// When null, [isSelected] is always false (use on a generic list manager).
  AllIngredientListsProvider._({
    required AllIngredientListsFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'allIngredientListsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allIngredientListsHash();

  @override
  String toString() {
    return r'allIngredientListsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<IngredientListEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<IngredientListEntry>> create(Ref ref) {
    final argument = this.argument as int?;
    return allIngredientLists(ref, ingredientId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllIngredientListsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allIngredientListsHash() => r'fff8b157b8cf8d8fb24de3578e235a2078dedc46';

/// Watches all user ingredient lists.
/// When [ingredientId] is provided (non-null), each entry's [isSelected]
/// and [ingredientCount] fields are populated.
/// When null, [isSelected] is always false (use on a generic list manager).

final class AllIngredientListsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<IngredientListEntry>>, int?> {
  AllIngredientListsFamily._()
    : super(
        retry: null,
        name: r'allIngredientListsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches all user ingredient lists.
  /// When [ingredientId] is provided (non-null), each entry's [isSelected]
  /// and [ingredientCount] fields are populated.
  /// When null, [isSelected] is always false (use on a generic list manager).

  AllIngredientListsProvider call({int? ingredientId}) =>
      AllIngredientListsProvider._(argument: ingredientId, from: this);

  @override
  String toString() => r'allIngredientListsProvider';
}

/// Watches all [Ingredient]s that belong to [listId].

@ProviderFor(ingredientsInList)
final ingredientsInListProvider = IngredientsInListFamily._();

/// Watches all [Ingredient]s that belong to [listId].

final class IngredientsInListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Ingredient>>,
          List<Ingredient>,
          Stream<List<Ingredient>>
        >
    with $FutureModifier<List<Ingredient>>, $StreamProvider<List<Ingredient>> {
  /// Watches all [Ingredient]s that belong to [listId].
  IngredientsInListProvider._({
    required IngredientsInListFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ingredientsInListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientsInListHash();

  @override
  String toString() {
    return r'ingredientsInListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Ingredient>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Ingredient>> create(Ref ref) {
    final argument = this.argument as int;
    return ingredientsInList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientsInListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientsInListHash() => r'5f983a0f8f5aede430315b520f86f54f2890508b';

/// Watches all [Ingredient]s that belong to [listId].

final class IngredientsInListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Ingredient>>, int> {
  IngredientsInListFamily._()
    : super(
        retry: null,
        name: r'ingredientsInListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches all [Ingredient]s that belong to [listId].

  IngredientsInListProvider call(int listId) =>
      IngredientsInListProvider._(argument: listId, from: this);

  @override
  String toString() => r'ingredientsInListProvider';
}
