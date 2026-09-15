import 'package:flavorly/features/shopping/data/models/shopping_item_model.dart';
import 'package:flavorly/features/shopping/domain/entities/shopping_item.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ShoppingService {
  static final ShoppingService instance = ShoppingService._internal();
  ShoppingService._internal() {
    _loadFromHive();
  }

  final Box<ShoppingItemModel> _box = Hive.box<ShoppingItemModel>('grocery_box');
  final ValueNotifier<List<ShoppingItem>> itemsNotifier = ValueNotifier([]);

  void _loadFromHive() {
    itemsNotifier.value = _box.values.map((model) => model.toEntity()).toList();
  }

  void addItems(List<String> ingredients, String recipeName) {
    for (final ing in ingredients) {
      final id = '${DateTime.now().microsecondsSinceEpoch}_$ing';
      final item = ShoppingItem(id: id, name: ing, recipeName: recipeName);
      _box.put(id, ShoppingItemModel.fromEntity(item));
    }
    _loadFromHive();
  }

  void addItem(String name, {String recipeName = 'Custom Item'}) {
    if (name.trim().isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final item = ShoppingItem(id: id, name: name.trim(), recipeName: recipeName);
    _box.put(id, ShoppingItemModel.fromEntity(item));
    _loadFromHive();
  }

  void toggleItem(String id) {
    final model = _box.get(id);
    if (model != null) {
      final updated = ShoppingItemModel(
        id: model.id,
        name: model.name,
        recipeName: model.recipeName,
        isBought: !model.isBought,
      );
      _box.put(id, updated);
      _loadFromHive();
    }
  }

  void clearAll() {
    _box.clear();
    _loadFromHive();
  }
}