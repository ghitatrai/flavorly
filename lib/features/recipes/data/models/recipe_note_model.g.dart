// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeNoteModelAdapter extends TypeAdapter<RecipeNoteModel> {
  @override
  final int typeId = 3;

  @override
  RecipeNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeNoteModel(
      recipeId: fields[0] as String,
      rating: fields[1] as double,
      notes: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeNoteModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
