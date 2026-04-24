import 'package:hive_flutter/hive_flutter.dart';

class KardexService {
  final String _boxName = 'kardexBox';

  Future<void> guardarSolucionBase({
    required String pacienteId,
    required Map<String, dynamic> datos,
  }) async {
    var box = await Hive.openBox(_boxName);
    
    // Obtenemos la lista actual de soluciones o creamos una nueva si no existe
    List<dynamic> soluciones = box.get(pacienteId, defaultValue: []) ?? [];
    
    // Agregamos la nueva solución
    soluciones.add(datos);
    
    // Guardamos la lista actualizada
    await box.put(pacienteId, soluciones);
  }
}
