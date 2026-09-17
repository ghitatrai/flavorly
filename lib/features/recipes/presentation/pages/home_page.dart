import 'package:flavorly/core/localization/app_localizations.dart';
import 'package:flavorly/features/meal_planner/presentation/pages/meal_planner_page.dart';
import 'package:flavorly/features/recipes/presentation/pages/add_custom_recipe_page.dart';
import 'package:dio/dio.dart';
import 'package:flavorly/features/recipes/presentation/widgets/kitchen_converter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_service.dart';
import '../../data/models/recipe_model.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import 'recipe_detail_page.dart';
import '../widgets/category_selector.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_card_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Chicken';
  bool _randomRecipeLoaderVisible = false;

  final List<String> _categories = [
    'Chicken',
    'Beef',
    'Dessert',
    'Pasta',
    'Seafood',
    'Vegetarian',
    'Breakfast'
  ];

  Future<void> _fetchAndNavigateRandom(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/random.php',
      );

      if (context.mounted) Navigator.pop(context);

      if (response.statusCode == 200 && response.data['meals'] != null) {
        final recipeModel = RecipeModel.fromJson(response.data['meals'][0]);
        final recipe = recipeModel.toEntity();

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: recipe),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to fetch random recipe. Check connection!',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RandomRecipeLoadingState) {
          _randomRecipeLoaderVisible = true;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is RandomRecipeLoadedState) {
          if (_randomRecipeLoaderVisible) {
            Navigator.of(context, rootNavigator: true).pop();
            _randomRecipeLoaderVisible = false;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipe: state.recipe),
            ),
          );
        } else if (state is RandomRecipeErrorState) {
          if (_randomRecipeLoaderVisible) {
            Navigator.of(context, rootNavigator: true).pop();
            _randomRecipeLoaderVisible = false;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not fetch random recipe. Check connection!',
              ),
            ),
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<String>(
          valueListenable: AppLocalizations.instance.currentLangNotifier,
          builder: (context, lang, _) {
            return Text(
              AppLocalizations.instance.translate('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Surprise Me!',
            onPressed: () => _fetchAndNavigateRandom(context),
          ),
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6),
            onSelected: (ThemeMode mode) {
              ThemeService.instance.updateThemeMode(mode);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto),
                    SizedBox(width: 8),
                    Text('System Default'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light Theme'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark Theme'),
                  ],
                ),
              ),
            ],
          ),
          // Import widget:
// import '../widgets/kitchen_converter_widget.dart';

// In AppBar actions list:
IconButton(
  icon: const Icon(Icons.calculate_outlined),
  tooltip: 'Kitchen Converter',
  onPressed: () {
    showDialog(
      context: context,
      builder: (_) => const KitchenConverterWidget(),
    );
  },
),
PopupMenuButton<String>(
  icon: const Icon(Icons.language),
  onSelected: (langCode) {
    AppLocalizations.instance.changeLanguage(langCode);
  },
  itemBuilder: (context) => const [
    PopupMenuItem(value: 'en', child: Text('English')),
    PopupMenuItem(value: 'fr', child: Text('Français')),
    PopupMenuItem(value: 'ar', child: Text('العربية')),
  ],
),
// Inside AppBar actions:
IconButton(
  icon: const Icon(Icons.calendar_month),
  tooltip: 'Weekly Meal Planner',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MealPlannerPage()),
    );
  },
),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: AppLocalizations.instance.currentLangNotifier,
              builder: (context, lang, _) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.instance.translate('search_hint'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      context.read<RecipeBloc>().add(
                        FetchRecipesEvent(query: query),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            CategorySelector(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelectCategory: (category) {
                setState(() => _selectedCategory = category);
                context.read<RecipeBloc>().add(FetchRecipesEvent(query: category));
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoadingState) {
                    return ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, __) => const RecipeCardSkeleton(),
                    );
                  } else if (state is RecipeLoadedState) {
                    if (state.recipes.isEmpty) {
                      return const Center(child: Text('No recipes found.'));
                    }
                    return ListView.separated(
                      itemCount: state.recipes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return RecipeCard(recipe: state.recipes[index]);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      // Import form page:
// import 'add_custom_recipe_page.dart';

// In HomePage Scaffold:
floatingActionButton: FloatingActionButton.extended(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCustomRecipePage()),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom recipe saved locally!')),
      );
    }
  },
  icon: const Icon(Icons.add),
  label: const Text('New Recipe'),
),
      ),
    );
  }
}