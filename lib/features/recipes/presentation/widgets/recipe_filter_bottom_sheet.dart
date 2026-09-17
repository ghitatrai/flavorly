import 'package:flutter/material.dart';
import '../../domain/entities/recipe_filter.dart';

class RecipeFilterBottomSheet extends StatefulWidget {
  final RecipeFilter initialFilter;
  final Function(RecipeFilter) onApply;

  const RecipeFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<RecipeFilterBottomSheet> createState() => _RecipeFilterBottomSheetState();
}

class _RecipeFilterBottomSheetState extends State<RecipeFilterBottomSheet> {
  late String? _dietary;
  late double _maxTime;

  final List<String?> _dietaryOptions = [null, 'Vegetarian', 'Vegan', 'Gluten-Free', 'Dairy-Free'];

  @override
  void initState() {
    super.initState();
    _dietary = widget.initialFilter.dietaryPreference;
    _maxTime = widget.initialFilter.maxPrepTimeMinutes.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter Recipes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Dietary Preference', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _dietaryOptions.map((option) {
              return ChoiceChip(
                label: Text(option ?? 'All'),
                selected: _dietary == option,
                onSelected: (selected) {
                  setState(() => _dietary = selected ? option : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Max Prep Time', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('${_maxTime.toInt()} mins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            ],
          ),
          Slider(
            value: _maxTime,
            min: 10,
            max: 120,
            divisions: 11,
            label: '${_maxTime.toInt()}m',
            onChanged: (val) => setState(() => _maxTime = val),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final filter = RecipeFilter(
                  dietaryPreference: _dietary,
                  maxPrepTimeMinutes: _maxTime.toInt(),
                );
                widget.onApply(filter);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}