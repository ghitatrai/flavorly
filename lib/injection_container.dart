import 'package:dio/dio.dart';
import 'package:flavorly/core/localization/app_localizations.dart';
import 'package:flavorly/core/theme/theme_service.dart';
import 'package:flavorly/features/recipes/data/models/custom_recipe_model.dart';
import 'package:flavorly/features/recipes/data/models/recipe_note_model.dart';
import 'package:flavorly/features/shopping/data/service/shopping_service.dart';
import 'package:flavorly/features/shopping/data/models/shopping_item_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/recipes/data/datasources/recipe_local_data_source.dart';
import 'features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'features/recipes/data/models/recipe_model.dart';
import 'features/recipes/data/repositories/recipe_repository_impl.dart';
import 'features/recipes/domain/repositories/recipe_repository.dart';
import 'features/recipes/presentation/bloc/recipe_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Hive Setup
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter());
  final favoriteBox = await Hive.openBox<RecipeModel>('favorites_box');

// Add this import at the top
// Import:

// Import model:
// Import model:

// Inside initDependencies():
Hive.registerAdapter(RecipeNoteModelAdapter());
final notesBox = await Hive.openBox<RecipeNoteModel>('recipe_notes_box');
sl.registerLazySingleton<Box<RecipeNoteModel>>(() => notesBox);
// Inside initDependencies():
Hive.registerAdapter(CustomRecipeModelAdapter());
final customRecipeBox = await Hive.openBox<CustomRecipeModel>('custom_recipes_box');
sl.registerLazySingleton<Box<CustomRecipeModel>>(() => customRecipeBox);
// Inside initDependencies():
await ThemeService.instance.init();
// Inside initDependencies():
Hive.registerAdapter(ShoppingItemModelAdapter());
final groceryBox = await Hive.openBox<ShoppingItemModel>('grocery_box');
sl.registerLazySingleton<Box<ShoppingItemModel>>(() => groceryBox);
ShoppingService.instance.initialize(groceryBox);
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => favoriteBox);

  // Data Sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(favoriteBox: sl()),
  );
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(remoteDataSource: sl()),
  );

  // BLoC
  sl.registerFactory(
    () => RecipeBloc(
      remoteDataSource: sl(),
      localDataSource: sl(),
      recipeRepository: sl(),
    ),
  );
  await AppLocalizations.instance.init();
}