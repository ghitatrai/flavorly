import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_info.dart';

class NutritionCardWidget extends StatelessWidget {
  final NutritionInfo nutrition;

  const NutritionCardWidget({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Estimated Nutrition (Per Serving)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroItem(label: 'Calories', value: '${nutrition.calories} kcal', color: Colors.deepOrange),
              _MacroItem(label: 'Protein', value: '${nutrition.proteinGrams}g', color: Colors.blue),
              _MacroItem(label: 'Carbs', value: '${nutrition.carbsGrams}g', color: Colors.amber),
              _MacroItem(label: 'Fat', value: '${nutrition.fatGrams}g', color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}