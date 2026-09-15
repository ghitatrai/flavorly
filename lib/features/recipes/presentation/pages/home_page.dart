import 'package:flavorly/features/recipes/presentation/pages/add_custom_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_service.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
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

  final List<String> _categories = [
    'Chicken',
    'Beef',
    'Dessert',
    'Pasta',
    'Seafood',
    'Vegetarian',
    'Breakfast'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavorly', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipe or ingredient...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<RecipeBloc>().add(FetchRecipesEvent(query: query));
                }
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
    );
  }
}