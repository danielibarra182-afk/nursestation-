// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientModelAdapter extends TypeAdapter<PatientModel> {
  @override
  final int typeId = 1;

  @override
  PatientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientModel(
      id: fields[0] as String,
      nombre: fields[1] as String,
      cama: fields[2] as String,
      edad: fields[3] as int,
      diagnostico: fields[4] as String,
      medicamentos: (fields[5] as List).cast<dynamic>(),
      notas: fields[6] as String,
      solucionesBase: (fields[7] as List?)?.cast<dynamic>(),
      infusiones: (fields[8] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PatientModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.cama)
      ..writeByte(3)
      ..write(obj.edad)
      ..writeByte(4)
      ..write(obj.diagnostico)
      ..writeByte(5)
      ..write(obj.medicamentos)
      ..writeByte(6)
      ..write(obj.notas)
      ..writeByte(7)
      ..write(obj.solucionesBase)
      ..writeByte(8)
      ..write(obj.infusiones);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
