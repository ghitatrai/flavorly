import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<void> cacheFavorite(RecipeModel recipe);
  Future<void> removeFavorite(String id);
  List<RecipeModel> getFavorites();
  bool isFavorite(String id);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final Box<RecipeModel> favoriteBox;

  RecipeLocalDataSourceImpl({required this.favoriteBox});

  @override
  Future<void> cacheFavorite(RecipeModel recipe) async {
    await favoriteBox.put(recipe.id, recipe);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await favoriteBox.delete(id);
  }

  @override
  List<RecipeModel> getFavorites() {
    return favoriteBox.values.toList();
  }

  @override
  bool isFavorite(String id) {
    return favoriteBox.containsKey(id);
  }
}