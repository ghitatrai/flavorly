import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final List<String> ingredients;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
    this.isFavorite = false,
  });

  Recipe copyWith({bool? isFavorite}) {
    return Recipe(
      id: id,
      name: name,
      category: category,
      area: area,
      instructions: instructions,
      thumbnailUrl: thumbnailUrl,
      ingredients: ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        area,
        instructions,
        thumbnailUrl,
        ingredients,
        isFavorite,
      ];
}