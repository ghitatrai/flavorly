import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/models/recipe_model.dart';

import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeBloc({
    required this.remoteDataSource,
    required this.localDataSource,
  }) : super(RecipeInitialState()) {
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  Future<void> _onFetchRecipes(
    FetchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoadingState());
    try {
      final remoteModels = await remoteDataSource.getRecipesByQuery(event.query);
      final recipes = remoteModels.map((model) {
        final isFav = localDataSource.isFavorite(model.id);
        return model.toEntity(isFavorite: isFav);
      }).toList();

      emit(RecipeLoadedState(recipes));
    } catch (e) {
      emit(RecipeErrorState('Failed to fetch recipes: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    final recipe = event.recipe;
    final model = RecipeModel.fromEntity(recipe);

    if (localDataSource.isFavorite(recipe.id)) {
      await localDataSource.removeFavorite(recipe.id);
    } else {
      await localDataSource.cacheFavorite(model);
    }

    if (state is RecipeLoadedState) {
      final currentList = (state as RecipeLoadedState).recipes;
      final updatedList = currentList.map((r) {
        if (r.id == recipe.id) {
          return r.copyWith(isFavorite: !r.isFavorite);
        }
        return r;
      }).toList();
      emit(RecipeLoadedState(updatedList));
    } else if (state is FavoritesLoadedState) {
      add(FetchFavoritesEvent());
    }
  }

  void _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<RecipeState> emit,
  ) {
    final favModels = localDataSource.getFavorites();
    final favEntities =
        favModels.map((model) => model.toEntity(isFavorite: true)).toList();
    emit(FavoritesLoadedState(favEntities));
  }
}