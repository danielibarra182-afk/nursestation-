import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/farmaco_model.dart';

class FarmacoService {
  Future<List<Farmaco>> cargarMedicamentos() async {
    try {
      print('--- CARGANDO MEDICAMENTOS ---');
      // Desactivamos el caché para que Flutter intente leer la versión más reciente del archivo
      final String response = await rootBundle.loadString('assets/data/medicamentos.json', cache: false);
      
      print('JSON cargado. Longitud: ${response.length} caracteres.');
      // Imprimimos un fragmento para verificar en consola si los cambios están ahí
      if (response.length > 100) {
        print('Primeros 100 caracteres: ${response.substring(0, 100)}');
      }

      final List<dynamic> data = json.decode(response);
      final List<Farmaco> lista = data.map((item) => Farmaco.fromJson(item)).toList();
      
      print('Carga completada: ${lista.length} medicamentos procesados.');
      return lista;
    } catch (e, stackTrace) {
      print('ERROR al cargar medicamentos: $e');
      print('Stacktrace: $stackTrace');
      return [];
    }
  }
}
