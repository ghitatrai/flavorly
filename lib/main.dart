import 'package:flavorly/features/shopping/presentation/pages/main_navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/widgets/offline_banner.dart';
import 'features/recipes/presentation/bloc/recipe_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<RecipeBloc>(),
      child: MaterialApp(
        title: 'Flavorly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return OfflineBanner(child: child ?? const SizedBox());
        },
        home: const MainNavigationPage(),
      ),
    );
  }
}