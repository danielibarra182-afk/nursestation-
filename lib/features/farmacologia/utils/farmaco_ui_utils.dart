import 'package:flutter/material.dart';

class FarmacoUIUtils {
  static const Map<String, Color> categoryColors = {
    'Cardiovascular': Color(0xFFE53935),
    'Antibióticos': Color(0xFF2E7D32),
    'Analgésicos': Color(0xFFFB8C00),
    'Neurología': Color(0xFF5E35B1),
    'Soluciones': Color(0xFF0288D1),
    'Anticoagulantes': Color(0xFF880E4F),
    'Digestivos': Color(0xFF8D6E63),
    'Electrolitos': Color(0xFF00ACC1),
    'Esteroides': Color(0xFF8E24AA),
    'Endocrinología': Color(0xFFD81B60),
    'Neumología': Color(0xFF607D8B),
    'Antivirales': Color(0xFFC0CA33),
    'Sedantes y anestésicos': Color(0xFF3F51B5),
  };

  static Color getCategoryColor(String category) {
    // Normalización para búsqueda flexible
    String normalized = category.trim();
    if (normalized.toLowerCase().contains('antiviral') || 
        normalized.toLowerCase().contains('antirretroviral')) {
      return categoryColors['Antivirales']!;
    }
    
    // Búsqueda exacta o parcial en el mapa
    for (var entry in categoryColors.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    return const Color(0xFF10B981); // Color por defecto
  }

  static Color getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
