import 'package:dio/dio.dart';
import 'package:flavorly/features/shopping/data/models/shopping_item_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/recipes/data/datasources/recipe_local_data_source.dart';
import 'features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'features/recipes/data/models/recipe_model.dart';
import 'features/recipes/presentation/bloc/recipe_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Hive Setup
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeModelAdapter());
  final favoriteBox = await Hive.openBox<RecipeModel>('favorites_box');

// Add this import at the top

// Inside initDependencies():
Hive.registerAdapter(ShoppingItemModelAdapter());
final groceryBox = await Hive.openBox<ShoppingItemModel>('grocery_box');
sl.registerLazySingleton<Box<ShoppingItemModel>>(() => groceryBox);
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

  // BLoC
  sl.registerFactory(
    () => RecipeBloc(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
}