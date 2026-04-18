import 'package:hive/hive.dart';

part 'patient_model.g.dart';

@HiveType(typeId: 1)
class PatientModel extends HiveObject {
  @HiveField(0)
  String nombre;

  @HiveField(1)
  int edad;

  @HiveField(2)
  String diagnostico;

  PatientModel({
    required this.nombre,
    required this.edad,
    required this.diagnostico,
  });
}
