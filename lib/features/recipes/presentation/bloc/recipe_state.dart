// recipe_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecipeInitialState extends RecipeState {}

class RecipeLoadingState extends RecipeState {}

class RecipeLoadedState extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoadedState(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class FavoritesLoadedState extends RecipeState {
  final List<Recipe> favorites;
  FavoritesLoadedState(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class RecipeErrorState extends RecipeState {
  final String message;
  RecipeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}