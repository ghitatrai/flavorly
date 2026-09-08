import 'package:hive/hive.dart';
import '../../domain/entities/recipe.dart';


@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String area;

  @HiveField(4)
  final String instructions;

  @HiveField(5)
  final String thumbnailUrl;

  @HiveField(6)
  final List<String> ingredients;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String> extractedIngredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final item = measure != null && measure.toString().trim().isNotEmpty
            ? '${measure.toString().trim()} ${ingredient.toString().trim()}'
            : ingredient.toString().trim();
        extractedIngredients.add(item);
      }
    }

    return RecipeModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnailUrl: json['strMealThumb'] ?? '',
      ingredients: extractedIngredients,
    );
  }

  Recipe toEntity({bool isFavorite = false}) {
    return Recipe(
      id: id,
      name: name,
      category: category,
      area: area,
      instructions: instructions,
      thumbnailUrl: thumbnailUrl,
      ingredients: ingredients,
      isFavorite: isFavorite,
    );
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      name: recipe.name,
      category: recipe.category,
      area: recipe.area,
      instructions: recipe.instructions,
      thumbnailUrl: recipe.thumbnailUrl,
      ingredients: recipe.ingredients,
    );
  }
}