import 'package:hive_flutter/hive_flutter.dart';
import '../../models/patient_model.dart';

class KardexService {
  Future<void> guardarSolucionBase({
    required String pacienteId,
    required Map<String, dynamic> datos,
  }) async {
    // Abrir la caja de pacientes sin tipado explícito
    var box = await Hive.openBox('pacientes');

    // Buscar al paciente por su pacienteId
    PatientModel? paciente = box.get(pacienteId) as PatientModel?;

    // Si la llave no era el ID, lo buscamos en los valores
    if (paciente == null) {
      try {
        paciente = box.values
                .firstWhere((p) => p is PatientModel && p.id == pacienteId)
            as PatientModel?;
      } catch (e) {
        paciente = null;
      }
    }

    // Si el paciente existe, añadir los nuevos datos a su lista de solucionesBase
    if (paciente != null) {
      // Reasignamos la lista para forzar a Hive a detectar el cambio
      final listaActualizada =
          List<dynamic>.from(paciente.solucionesBase ?? []);
      listaActualizada.add(datos);
      paciente.solucionesBase = listaActualizada;

      // Guardar el objeto actualizado en Hive usando put o save
      if (paciente.isInBox) {
        await paciente.save();
      } else if (paciente.key != null) {
        await box.put(paciente.key, paciente);
      } else {
        await box.put(paciente.id, paciente);
      }
    }
  }

  Future<void> guardarInfusion({
    required String pacienteId,
    required Map<String, dynamic> datos,
  }) async {
    var box = await Hive.openBox('pacientes');
    PatientModel? paciente = box.get(pacienteId) as PatientModel?;
    if (paciente == null) {
      try {
        paciente = box.values
                .firstWhere((p) => p is PatientModel && p.id == pacienteId)
            as PatientModel?;
      } catch (e) {
        paciente = null;
      }
    }

    if (paciente != null) {
      final listaActualizada =
          List<dynamic>.from(paciente.infusiones ?? []);
      listaActualizada.add(datos);
      paciente.infusiones = listaActualizada;

      if (paciente.isInBox) {
        await paciente.save();
      } else if (paciente.key != null) {
        await box.put(paciente.key, paciente);
      } else {
        await box.put(paciente.id, paciente);
      }
    }
  }
  Future<void> guardarMedicamento({
    required String pacienteId,
    required Map<String, dynamic> datos,
  }) async {
    var box = await Hive.openBox('pacientes');
    PatientModel? paciente = box.get(pacienteId) as PatientModel?;
    if (paciente == null) {
      try {
        paciente = box.values
                .firstWhere((p) => p is PatientModel && p.id == pacienteId)
            as PatientModel?;
      } catch (e) {
        paciente = null;
      }
    }

    if (paciente != null) {
      final listaActualizada =
          List<dynamic>.from(paciente.medicamentos ?? []);
      listaActualizada.add(datos);
      paciente.medicamentos = listaActualizada;

      if (paciente.isInBox) {
        await paciente.save();
      } else if (paciente.key != null) {
        await box.put(paciente.key, paciente);
      } else {
        await box.put(paciente.id, paciente);
      }
    }
  }

  Future<void> actualizarMedicamento({
    required String pacienteId,
    required Map<String, dynamic> medicamentoActualizado,
  }) async {
    var box = await Hive.openBox('pacientes');
    PatientModel? paciente = box.get(pacienteId) as PatientModel?;
    if (paciente == null) {
      try {
        paciente = box.values
                .firstWhere((p) => p is PatientModel && p.id == pacienteId)
            as PatientModel?;
      } catch (e) {
        paciente = null;
      }
    }

    if (paciente != null) {
      final listaActualizada =
          List<dynamic>.from(paciente.medicamentos ?? []);
      
      final index = listaActualizada.indexWhere(
          (m) => m['id'] == medicamentoActualizado['id']);
          
      if (index != -1) {
        listaActualizada[index] = medicamentoActualizado;
        paciente.medicamentos = listaActualizada;

        if (paciente.isInBox) {
          await paciente.save();
        } else if (paciente.key != null) {
          await box.put(paciente.key, paciente);
        } else {
          await box.put(paciente.id, paciente);
        }
      }
    }
  }
}
