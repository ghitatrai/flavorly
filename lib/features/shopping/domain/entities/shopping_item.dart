class ShoppingItem {
  final String id;
  final String name;
  final String recipeName;
  final bool isBought;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.recipeName,
    this.isBought = false,
  });

  ShoppingItem copyWith({bool? isBought}) {
    return ShoppingItem(
      id: id,
      name: name,
      recipeName: recipeName,
      isBought: isBought ?? this.isBought,
    );
  }
}