import 'package:dio/dio.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipesByQuery(String query);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
  Future<RecipeModel> getRandomRecipe();
  
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;
  

  RecipeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RecipeModel>> getRecipesByQuery(String query) async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/search.php',
      queryParameters: {'s': query},
    );

    if (response.data['meals'] == null) return [];

    final List mealsJson = response.data['meals'];
    return mealsJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/filter.php',
      queryParameters: {'c': category},
    );

    if (response.data['meals'] == null) return [];

    final List mealsJson = response.data['meals'];
    return mealsJson.map((json) => RecipeModel.fromJson(json)).toList();
  }

  @override
  Future<RecipeModel> getRandomRecipe() async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/random.php',
    );

    if (response.statusCode == 200) {
      final data = response.data['meals'][0];
      return RecipeModel.fromJson(data);
    }

    throw Exception('Failed to load random recipe');
  }

  // Add method to get categories list
Future<List<String>> getCategories() async {
  final response = await dio.get('https://www.themealdb.com/api/json/v1/1/list.php?c=list');
  if (response.data['meals'] == null) return [];
  final List categoriesJson = response.data['meals'];
  return categoriesJson.map((e) => e['strCategory'].toString()).toList();
}

}