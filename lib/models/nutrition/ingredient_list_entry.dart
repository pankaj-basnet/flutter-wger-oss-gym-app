class IngredientListEntry {
  final int id;
  final String name;
  final bool isSelected;
  final int ingredientCount;

  IngredientListEntry({
    required this.id,
    required this.name,
    required this.isSelected,
    this.ingredientCount = 0,
  });

  // Optional: Add a copyWith to make state updates easier if needed later
  IngredientListEntry copyWith({
    int? id,
    String? name,
    bool? isSelected,
    int? ingredientCount,
  }) {
    return IngredientListEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      ingredientCount: ingredientCount ?? this.ingredientCount,
    );
  }
}
