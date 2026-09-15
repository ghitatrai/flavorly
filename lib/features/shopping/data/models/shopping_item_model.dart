import 'package:flavorly/features/shopping/domain/entities/shopping_item.dart';
import 'package:hive/hive.dart';

part 'shopping_item_model.g.dart';

@HiveType(typeId: 1)
class ShoppingItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String recipeName;

  @HiveField(3)
  final bool isBought;

  ShoppingItemModel({
    required this.id,
    required this.name,
    required this.recipeName,
    required this.isBought,
  });

  factory ShoppingItemModel.fromEntity(ShoppingItem item) {
    return ShoppingItemModel(
      id: item.id,
      name: item.name,
      recipeName: item.recipeName,
      isBought: item.isBought,
    );
  }

  ShoppingItem toEntity() {
    return ShoppingItem(
      id: id,
      name: name,
      recipeName: recipeName,
      isBought: isBought,
    );
  }
}