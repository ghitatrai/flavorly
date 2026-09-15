import 'package:flavorly/features/shopping/data/service/shopping_service.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/shopping_item.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Shopping List'),
        actions: [
          ValueListenableBuilder<List<ShoppingItem>>(
            valueListenable: ShoppingService.instance.itemsNotifier,
            builder: (context, items, _) {
              if (items.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => ShoppingService.instance.clearAll(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add extra grocery item...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: (val) {
                      ShoppingService.instance.addItem(val);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    ShoppingService.instance.addItem(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<ShoppingItem>>(
              valueListenable: ShoppingService.instance.itemsNotifier,
              builder: (context, items, _) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Your shopping list is empty.\nExport ingredients from any recipe!'),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CheckboxListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isBought ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(item.recipeName, style: const TextStyle(fontSize: 12)),
                      value: item.isBought,
                      onChanged: (_) {
                        ShoppingService.instance.toggleItem(item.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}