import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
	final RecipeRemoteDataSource remoteDataSource;

	RecipeRepositoryImpl({required this.remoteDataSource});

	@override
	Future<Recipe> getRandomRecipe() async {
		return (await remoteDataSource.getRandomRecipe()).toEntity();
	}
}
