import 'package:hive/hive.dart';

part 'meal_plan_model.g.dart';

@HiveType(typeId: 4)
class MealPlanModel extends HiveObject {
  @HiveField(0)
  final String id; // format: 'Day_Slot' e.g. 'Monday_Breakfast'

  @HiveField(1)
  final String day;

  @HiveField(2)
  final String slot; // Breakfast, Lunch, Dinner

  @HiveField(3)
  final String recipeName;

  @HiveField(4)
  final List<String> ingredients;

  MealPlanModel({
    required this.id,
    required this.day,
    required this.slot,
    required this.recipeName,
    required this.ingredients,
  });
}