import 'package:hive/hive.dart';

part 'custom_recipe_model.g.dart';

@HiveType(typeId: 2)
class CustomRecipeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final List<String> ingredients;

  @HiveField(5)
  final String instructions;

  CustomRecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.ingredients,
    required this.instructions,
  });
}