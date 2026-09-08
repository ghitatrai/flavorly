// recipe_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRecipesEvent extends RecipeEvent {
  final String query;
  FetchRecipesEvent({this.query = 'Chicken'});
}

class ToggleFavoriteEvent extends RecipeEvent {
  final Recipe recipe;
  ToggleFavoriteEvent(this.recipe);
}

class FetchFavoritesEvent extends RecipeEvent {}