class NutritionInfo {
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;

  const NutritionInfo({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  // Generate mock realistic macros based on recipe name/ingredients length for dynamic display
  factory NutritionInfo.fromRecipe(String recipeName, int ingredientCount) {
    final baseHash = recipeName.codeUnits.fold(0, (prev, element) => prev + element);
    return NutritionInfo(
      calories: 350 + (baseHash % 300),
      proteinGrams: 20 + (baseHash % 25),
      carbsGrams: 30 + (ingredientCount * 4),
      fatGrams: 10 + (baseHash % 15),
    );
  }
}