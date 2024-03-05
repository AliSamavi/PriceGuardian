// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreModelAdapter extends TypeAdapter<StoreModel> {
  @override
  final int typeId = 1;

  @override
  StoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StoreModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.xpath)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.percent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
