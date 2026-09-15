import 'package:flutter/material.dart';
import '../../domain/entities/shopping_item.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingItem> _items = [];
  final TextEditingController _controller = TextEditingController();

  void _addItem(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      _items.add(ShoppingItem(
        id: DateTime.now().toString(),
        name: name.trim(),
        recipeName: 'Custom Item',
      ));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Shopping List'),
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => setState(() => _items.clear()),
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
                    onSubmitted: _addItem,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addItem(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Your shopping list is empty.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return CheckboxListTile(
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.isBought ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(item.recipeName, style: const TextStyle(fontSize: 12)),
                        value: item.isBought,
                        onChanged: (val) {
                          setState(() {
                            _items[index] = item.copyWith(isBought: val ?? false);
                          });
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