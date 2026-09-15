// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomRecipeModelAdapter extends TypeAdapter<CustomRecipeModel> {
  @override
  final int typeId = 2;

  @override
  CustomRecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomRecipeModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      imagePath: fields[3] as String,
      ingredients: (fields[4] as List).cast<String>(),
      instructions: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomRecipeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.instructions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
