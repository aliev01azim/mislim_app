// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shahe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShaheModelAdapter extends TypeAdapter<ShaheModel> {
  @override
  final int typeId = 1;

  @override
  ShaheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShaheModel(
      id: fields[0] as int,
      name: fields[1] as String,
      isFavorite: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ShaheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShaheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
