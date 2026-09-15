import 'package:flavorly/features/shopping/domain/entities/shopping_item.dart';
import 'package:flutter/foundation.dart';

class ShoppingService {
  // Singleton pattern so the whole app accesses the exact same list
  static final ShoppingService instance = ShoppingService._internal();
  ShoppingService._internal();

  final ValueNotifier<List<ShoppingItem>> itemsNotifier = ValueNotifier([]);

  void addItems(List<String> ingredients, String recipeName) {
    final newItems = ingredients.map((ing) {
      return ShoppingItem(
        id: DateTime.now().microsecondsSinceEpoch.toString() + ing,
        name: ing,
        recipeName: recipeName,
      );
    }).toList();

    itemsNotifier.value = [...itemsNotifier.value, ...newItems];
  }

  void addItem(String name, {String recipeName = 'Custom Item'}) {
    if (name.trim().isEmpty) return;
    final item = ShoppingItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      recipeName: recipeName,
    );
    itemsNotifier.value = [...itemsNotifier.value, item];
  }

  void toggleItem(String id) {
    itemsNotifier.value = itemsNotifier.value.map((item) {
      if (item.id == id) {
        return item.copyWith(isBought: !item.isBought);
      }
      return item;
    }).toList();
  }

  void clearAll() {
    itemsNotifier.value = [];
  }
}