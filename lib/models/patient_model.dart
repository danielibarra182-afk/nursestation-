import 'package:hive/hive.dart';

part 'patient_model.g.dart';

@HiveType(typeId: 1)
class PatientModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String cama;

  @HiveField(3)
  int edad;

  @HiveField(4)
  String diagnostico;

  @HiveField(5)
  List<dynamic> medicamentos;

  @HiveField(6)
  String notas;

  @HiveField(7)
  List<dynamic>? solucionesBase;

  @HiveField(8)
  List<dynamic>? infusiones;

  @HiveField(9)
  List<dynamic>? signosVitales;

  @HiveField(10)
  String? fechaNacimiento;

  @HiveField(11)
  String? alergias;

  PatientModel({
    required this.id,
    required this.nombre,
    required this.cama,
    required this.edad,
    required this.diagnostico,
    required this.medicamentos,
    required this.notas,
    this.solucionesBase,
    this.infusiones,
    this.signosVitales,
    this.fechaNacimiento,
    this.alergias,
  });
}
