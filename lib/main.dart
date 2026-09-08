import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/recipes/presentation/bloc/recipe_bloc.dart';
import 'features/recipes/presentation/bloc/recipe_event.dart';
import 'features/recipes/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<RecipeBloc>()..add(FetchRecipesEvent(query: 'Pasta')),
      child: MaterialApp(
        title: 'Recipe Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFFF6B6B),
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        ),
        home: const HomePage(),
      ),
    );
  }
}