import 'package:flavorly/features/shopping/data/models/shopping_item_model.dart';
import 'package:flavorly/features/shopping/domain/entities/shopping_item.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ShoppingService {
  static final ShoppingService instance = ShoppingService._internal();
  ShoppingService._internal();

  Box<ShoppingItemModel>? _box;
  final ValueNotifier<List<ShoppingItem>> itemsNotifier = ValueNotifier([]);

  void initialize(Box<ShoppingItemModel> box) {
    _box = box;
    _loadFromHive();
  }

  Box<ShoppingItemModel> get _storageBox {
    final box = _box;
    if (box == null) {
      throw StateError('ShoppingService must be initialized before use.');
    }
    return box;
  }

  void _loadFromHive() {
    itemsNotifier.value = _storageBox.values.map((model) => model.toEntity()).toList();
  }

  void addItems(List<String> ingredients, String recipeName) {
    for (final ing in ingredients) {
      final id = '${DateTime.now().microsecondsSinceEpoch}_$ing';
      final item = ShoppingItem(id: id, name: ing, recipeName: recipeName);
      _storageBox.put(id, ShoppingItemModel.fromEntity(item));
    }
    _loadFromHive();
  }

  void addItem(String name, {String recipeName = 'Custom Item'}) {
    if (name.trim().isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final item = ShoppingItem(id: id, name: name.trim(), recipeName: recipeName);
    _storageBox.put(id, ShoppingItemModel.fromEntity(item));
    _loadFromHive();
  }

  void toggleItem(String id) {
    final model = _storageBox.get(id);
    if (model != null) {
      final updated = ShoppingItemModel(
        id: model.id,
        name: model.name,
        recipeName: model.recipeName,
        isBought: !model.isBought,
      );
      _storageBox.put(id, updated);
      _loadFromHive();
    }
  }

  void clearAll() {
    _storageBox.clear();
    _loadFromHive();
  }
}