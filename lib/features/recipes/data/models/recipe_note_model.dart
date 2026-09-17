import 'package:hive/hive.dart';

part 'recipe_note_model.g.dart';

@HiveType(typeId: 3)
class RecipeNoteModel extends HiveObject {
  @HiveField(0)
  final String recipeId;

  @HiveField(1)
  final double rating;

  @HiveField(2)
  final String notes;

  RecipeNoteModel({
    required this.recipeId,
    required this.rating,
    required this.notes,
  });
}