class RecipeFilter {
  final String? dietaryPreference; // 'Vegetarian', 'Vegan', 'Gluten-Free', etc.
  final int maxPrepTimeMinutes;

  const RecipeFilter({
    this.dietaryPreference,
    this.maxPrepTimeMinutes = 60,
  });

  RecipeFilter copyWith({
    String? dietaryPreference,
    int? maxPrepTimeMinutes,
  }) {
    return RecipeFilter(
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      maxPrepTimeMinutes: maxPrepTimeMinutes ?? this.maxPrepTimeMinutes,
    );
  }
}