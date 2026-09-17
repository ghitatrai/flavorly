import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/models/recipe_note_model.dart';

class RecipeNotesWidget extends StatefulWidget {
  final String recipeId;

  const RecipeNotesWidget({super.key, required this.recipeId});

  @override
  State<RecipeNotesWidget> createState() => _RecipeNotesWidgetState();
}

class _RecipeNotesWidgetState extends State<RecipeNotesWidget> {
  late Box<RecipeNoteModel> _notesBox;
  double _rating = 5.0;
  final TextEditingController _notesController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<RecipeNoteModel>('recipe_notes_box');
    _loadNoteData();
  }

  void _loadNoteData() {
    final noteModel = _notesBox.get(widget.recipeId);
    if (noteModel != null) {
      setState(() {
        _rating = noteModel.rating;
        _notesController.text = noteModel.notes;
      });
    }
  }

  void _saveNoteData() {
    final noteModel = RecipeNoteModel(
      recipeId: widget.recipeId,
      rating: _rating,
      notes: _notesController.text.trim(),
    );
    _notesBox.put(widget.recipeId, noteModel);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal notes & rating saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Notes & Rating',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 20),
                onPressed: () {
                  if (_isEditing) {
                    _saveNoteData();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              );
            }),
          ),
          const SizedBox(height: 12),
          if (_isEditing) ...[
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (val) => setState(() => _rating = val),
            ),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add your custom cooking notes or tweaks...',
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            Text(
              _notesController.text.isEmpty
                  ? 'No personal notes added yet. Tap edit to add tips!'
                  : _notesController.text,
              style: TextStyle(
                color: _notesController.text.isEmpty ? Colors.grey : Colors.indigo,
                fontStyle: _notesController.text.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}