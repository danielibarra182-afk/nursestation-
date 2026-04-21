import 'package:hive_flutter/hive_flutter.dart';
import '../models/patient_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PatientModelAdapter());

    await Hive.openBox('pacientes');
    await Hive.openBox('usuario');
  }
}