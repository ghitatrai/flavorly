import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../widgets/cooking_timer_widget.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final Set<String> _checkedIngredients = {};

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: recipe.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  context.read<RecipeBloc>().add(ToggleFavoriteEvent(recipe));
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    if (recipe.category.isNotEmpty) Chip(label: Text(recipe.category)),
                    const SizedBox(width: 8),
                    if (recipe.area.isNotEmpty) Chip(label: Text(recipe.area)),
                  ],
                ),
                const SizedBox(height: 16),
                const CookingTimerWidget(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ingredients Checklist',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_checkedIngredients.length}/${recipe.ingredients.length}',
                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map(
                  (item) {
                    final isChecked = _checkedIngredients.contains(item);
                    return CheckboxListTile(
                      title: Text(
                        item,
                        style: TextStyle(
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey : Colors.black,
                        ),
                      ),
                      value: isChecked,
                      activeColor: Colors.green,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _checkedIngredients.add(item);
                          } else {
                            _checkedIngredients.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.instructions,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}