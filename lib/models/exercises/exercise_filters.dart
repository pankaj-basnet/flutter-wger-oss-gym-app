import 'package:equatable/equatable.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/providers/nutrition_repository.dart' show IngredientSearchLanguage;

typedef ExerciseSearchLanguage = IngredientSearchLanguage;

enum ExerciseSearchMode {
  exact,
  fulltext,
}

// _sentinel to clear category (selectedCategory = null)
const Object _sentinel = Object();

class ExerciseFilters extends Equatable {
  final ExerciseSearchLanguage searchLanguage;
  final ExerciseSearchMode searchMode;
  final ExerciseCategory? selectedCategory;

  const ExerciseFilters({
    this.searchLanguage = ExerciseSearchLanguage.currentAndEnglish,
    this.searchMode = ExerciseSearchMode.fulltext,
    this.selectedCategory,
  });

  ExerciseFilters copyWith({
    ExerciseSearchLanguage? searchLanguage,
    ExerciseSearchMode? searchMode,
    Object? selectedCategory = _sentinel,
  }) {
    return ExerciseFilters(
      searchLanguage: searchLanguage ?? this.searchLanguage,
      searchMode: searchMode ?? this.searchMode,
      selectedCategory: identical(selectedCategory, _sentinel)
          ? this.selectedCategory
          : selectedCategory as ExerciseCategory?,
    );
  }

  @override
  List<Object?> get props => [searchLanguage, searchMode, selectedCategory];

  @override
  String toString() =>
      'ExerciseFilters(lang: $searchLanguage, mode: $searchMode, cat: ${selectedCategory?.name})';
}
