import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../widgets/recipe_card.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavorly Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes (e.g. Pasta, Chicken)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<RecipeBloc>().add(FetchRecipesEvent(query: ''));
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context.read<RecipeBloc>().add(FetchRecipesEvent(query: query));
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoadingState) {
                    return const Center(child: CircularProgressIndicator());
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
                  } else if (state is RecipeErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Search for delicious recipes!'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}