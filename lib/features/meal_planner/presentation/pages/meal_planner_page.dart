import 'package:flutter/material.dart';
import '../../data/meal_plan_model.dart';
import '../../data/meal_plan_service.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  final List<String> _days = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _slots = const ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_check),
            tooltip: 'Export Weekly Ingredients to Grocery',
            onPressed: () {
              MealPlanService.instance.exportAllToGrocery();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exported all weekly meal ingredients to grocery list!')),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<MealPlanModel>>(
        valueListenable: MealPlanService.instance.plansNotifier,
        builder: (context, plans, _) {
          return ListView.builder(
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final day = _days[index];
              return ExpansionTile(
                title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                children: _slots.map((slot) {
                  final planId = '${day}_$slot';
                  final currentPlan = plans.where((p) => p.id == planId).firstOrNull;

                  return ListTile(
                    leading: Icon(
                      slot == 'Breakfast' ? Icons.free_breakfast : slot == 'Lunch' ? Icons.lunch_dining : Icons.dinner_dining,
                      color: Colors.deepOrange,
                    ),
                    title: Text(slot, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(currentPlan != null ? currentPlan.recipeName : 'No meal planned yet'),
                    trailing: currentPlan != null
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => MealPlanService.instance.removeMeal(planId),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _showAddMealDialog(context, day, slot),
                          ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddMealDialog(BuildContext context, String day, String slot) {
    final titleController = TextEditingController();
    final ingController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Plan $slot for $day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Recipe / Meal Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ingController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Ingredients (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final ingredients = ingController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                MealPlanService.instance.setMeal(
                  day: day,
                  slot: slot,
                  recipeName: titleController.text.trim(),
                  ingredients: ingredients.isEmpty ? [titleController.text.trim()] : ingredients,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}