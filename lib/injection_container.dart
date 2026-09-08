import 'package:dio/dio.dart';
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