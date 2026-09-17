import 'package:flutter/material.dart';
import '../../../../core/utils/kitchen_converter.dart';

class KitchenConverterWidget extends StatefulWidget {
  const KitchenConverterWidget({super.key});

  @override
  State<KitchenConverterWidget> createState() => _KitchenConverterWidgetState();
}

class _KitchenConverterWidgetState extends State<KitchenConverterWidget> {
  bool _isTempMode = true;
  final TextEditingController _inputController = TextEditingController(text: '1');
  String _selectedIngredient = 'Flour';
  double _result = 125;

  final List<String> _ingredients = ['Flour', 'Sugar (Granulated)', 'Butter', 'Brown Sugar', 'Cocoa Powder'];

  void _calculate() {
    final val = double.tryParse(_inputController.text) ?? 0.0;
    setState(() {
      if (_isTempMode) {
        _result = KitchenConverter.celsiusToFahrenheit(val);
      } else {
        _result = KitchenConverter.cupsToGrams(_selectedIngredient, val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kitchen Unit Converter'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Temperature')),
                ButtonSegment(value: false, label: Text('Cups to Grams')),
              ],
              selected: {_isTempMode},
              onSelectionChanged: (val) {
                setState(() {
                  _isTempMode = val.first;
                  _inputController.text = '1';
                  _calculate();
                });
              },
            ),
            const SizedBox(height: 20),
            if (!_isTempMode) ...[
              DropdownButtonFormField<String>(
                value: _selectedIngredient,
                decoration: const InputDecoration(labelText: 'Ingredient', border: OutlineInputBorder()),
                items: _ingredients.map((ing) => DropdownMenuItem(value: ing, child: Text(ing))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedIngredient = val);
                    _calculate();
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _isTempMode ? 'Celsius (°C)' : 'Cups',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isTempMode
                    ? 'Result: ${_result.toStringAsFixed(1)} °F'
                    : 'Result: ${_result.toStringAsFixed(1)} grams',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}