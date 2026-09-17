// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealPlanModelAdapter extends TypeAdapter<MealPlanModel> {
  @override
  final int typeId = 4;

  @override
  MealPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlanModel(
      id: fields[0] as String,
      day: fields[1] as String,
      slot: fields[2] as String,
      recipeName: fields[3] as String,
      ingredients: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealPlanModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.slot)
      ..writeByte(3)
      ..write(obj.recipeName)
      ..writeByte(4)
      ..write(obj.ingredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
