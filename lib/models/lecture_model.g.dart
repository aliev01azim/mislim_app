// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureModelAdapter extends TypeAdapter<LectureModel> {
  @override
  final int typeId = 2;

  @override
  LectureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LectureModel(
      id: fields[0] as int,
      categoryId: fields[5] as int,
      categoryTitle: fields[6] as String,
      author: fields[4] as ShaheModel,
      title: fields[1] as String,
      isFavorite: fields[7] as bool?,
      lectureFile: fields[2] as String,
      dueTime: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LectureModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lectureFile)
      ..writeByte(3)
      ..write(obj.dueTime)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.categoryTitle)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
