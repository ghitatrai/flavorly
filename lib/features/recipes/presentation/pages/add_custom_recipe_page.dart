import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/custom_recipe_model.dart';

class AddCustomRecipePage extends StatefulWidget {
  const AddCustomRecipePage({super.key});

  @override
  State<AddCustomRecipePage> createState() => _AddCustomRecipePageState();
}

class _AddCustomRecipePageState extends State<AddCustomRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ingredientController = TextEditingController();

  final List<String> _ingredients = [];
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient.')),
        );
        return;
      }

      final customRecipe = CustomRecipeModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'Custom' : _categoryController.text.trim(),
        imagePath: _imagePath ?? '',
        ingredients: _ingredients,
        instructions: _instructionsController.text.trim(),
      );

      final box = Hive.box<CustomRecipeModel>('custom_recipes_box');
      box.put(customRecipe.id, customRecipe);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Custom Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Tap to select photo'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Recipe Title*', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category (e.g. Dinner, Snack)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientController,
                      decoration: const InputDecoration(hintText: 'Add an ingredient...'),
                      onSubmitted: (_) => _addIngredient(),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.add), onPressed: _addIngredient),
                ],
              ),
              Wrap(
                spacing: 6,
                children: _ingredients
                    .map((ing) => Chip(
                          label: Text(ing),
                          onDeleted: () => setState(() => _ingredients.remove(ing)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Instructions*', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Instructions are required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveRecipe,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Recipe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}