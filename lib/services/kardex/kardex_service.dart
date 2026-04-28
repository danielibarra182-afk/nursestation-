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

  Future<void> actualizarSolucionBase({
    required String pacienteId,
    required Map<String, dynamic> solucionActualizada,
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
      final lista = List<dynamic>.from(paciente.solucionesBase ?? []);
      final index = lista.indexWhere((s) => s['id'] == solucionActualizada['id']);
      if (index != -1) {
        lista[index] = solucionActualizada;
        paciente.solucionesBase = lista;

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

  Future<void> eliminarSolucionBase({
    required String pacienteId,
    required String solucionId,
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
      final lista = List<dynamic>.from(paciente.solucionesBase ?? []);
      lista.removeWhere((s) => s['id'] == solucionId);
      paciente.solucionesBase = lista;

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

  Future<void> actualizarInfusion({
    required String pacienteId,
    required Map<String, dynamic> infusionActualizada,
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
      final lista = List<dynamic>.from(paciente.infusiones ?? []);
      final index = lista.indexWhere((s) => s['id'] == infusionActualizada['id']);
      if (index != -1) {
        lista[index] = infusionActualizada;
        paciente.infusiones = lista;

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

  Future<void> eliminarInfusion({
    required String pacienteId,
    required String infusionId,
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
      final lista = List<dynamic>.from(paciente.infusiones ?? []);
      lista.removeWhere((s) => s['id'] == infusionId);
      paciente.infusiones = lista;

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

  Future<void> guardarSignosVitales({
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
      final lista = List<dynamic>.from(paciente.signosVitales ?? []);
      lista.add(datos);
      paciente.signosVitales = lista;

      if (paciente.isInBox) {
        await paciente.save();
      } else if (paciente.key != null) {
        await box.put(paciente.key, paciente);
      } else {
        await box.put(paciente.id, paciente);
      }
    }
  }

  Future<void> actualizarSignosVitales({
    required String pacienteId,
    required Map<String, dynamic> signosActualizados,
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
      final lista = List<dynamic>.from(paciente.signosVitales ?? []);
      final index = lista.indexWhere((s) => s['id'] == signosActualizados['id']);
      if (index != -1) {
        lista[index] = signosActualizados;
        paciente.signosVitales = lista;

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

  Future<void> eliminarSignosVitales({
    required String pacienteId,
    required String signoId,
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
      final lista = List<dynamic>.from(paciente.signosVitales ?? []);
      lista.removeWhere((s) => s['id'] == signoId);
      paciente.signosVitales = lista;

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

  Future<void> eliminarMedicamento({
    required String pacienteId,
    required String medicamentoId,
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
      
      listaActualizada.removeWhere((m) => m['id'] == medicamentoId);
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
