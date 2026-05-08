import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/farmaco_model.dart';

class FarmacoService {
  Future<List<Farmaco>> cargarMedicamentos() async {
    try {
      print('Cargando medicamentos desde assets...');
      final String response = await rootBundle.loadString('assets/data/medicamentos.json');
      print('Archivo JSON cargado correctamente. Longitud: ${response.length}');
      
      final List<dynamic> data = json.decode(response);
      print('JSON decodificado. Número de elementos: ${data.length}');
      
      final List<Farmaco> lista = data.map((item) => Farmaco.fromJson(item)).toList();
      print('Mapeo a Farmaco completado. Total: ${lista.length}');
      
      return lista;
    } catch (e, stackTrace) {
      print('ERROR FATAL cargando medicamentos: $e');
      print('Stacktrace: $stackTrace');
      return [];
    }
  }
}
