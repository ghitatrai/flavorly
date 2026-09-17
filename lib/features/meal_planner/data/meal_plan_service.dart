import 'package:flavorly/features/shopping/data/service/shopping_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'meal_plan_model.dart';
import '../../shopping/data/shopping_service.dart';

class MealPlanService {
  static final MealPlanService instance = MealPlanService._internal();
  MealPlanService._internal() {
    _loadFromHive();
  }

  final Box<MealPlanModel> _box = Hive.box<MealPlanModel>('meal_planner_box');
  final ValueNotifier<List<MealPlanModel>> plansNotifier = ValueNotifier([]);

  void _loadFromHive() {
    plansNotifier.value = _box.values.toList();
  }

  void setMeal({
    required String day,
    required String slot,
    required String recipeName,
    required List<String> ingredients,
  }) {
    final id = '${day}_$slot';
    final model = MealPlanModel(
      id: id,
      day: day,
      slot: slot,
      recipeName: recipeName,
      ingredients: ingredients,
    );
    _box.put(id, model);
    _loadFromHive();
  }

  void removeMeal(String id) {
    _box.delete(id);
    _loadFromHive();
  }

  void exportAllToGrocery() {
    for (final plan in _box.values) {
      ShoppingService.instance.addItems(
        plan.ingredients,
        '${plan.day} (${plan.slot}): ${plan.recipeName}',
      );
    }
  }
}