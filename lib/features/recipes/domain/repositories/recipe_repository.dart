import '../entities/recipe.dart';

abstract class RecipeRepository {
	Future<Recipe> getRandomRecipe();
}
