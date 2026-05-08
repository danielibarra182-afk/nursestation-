import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'farmaco_model.g.dart';

// ─────────────────────────────────────────────────────────────
//  TIPOS DE ADAPTADOR HIVE  (typeId únicos, no cambiar)
//  FarmacoModel          → typeId: 10
//  CategoriaFarmaco      → typeId: 11
//  RiesgoEmbarazo        → typeId: 12
// ─────────────────────────────────────────────────────────────

// ─── ENUM: Categoría ─────────────────────────────────────────

@HiveType(typeId: 11)
enum CategoriaFarmaco {
  @HiveField(0)
  analgesicos,

  @HiveField(1)
  antibioticos,

  @HiveField(2)
  cardiovascular,

  @HiveField(3)
  digestivos,

  @HiveField(4)
  anticoagulantes,

  @HiveField(5)
  esteroides,

  @HiveField(6)
  soluciones,

  @HiveField(7)
  electrolitos,

  @HiveField(8)
  endocrinologia,

  @HiveField(9)
  neumologia,

  @HiveField(10)
  neurologia,

  @HiveField(11)
  otros,
}

// ─── ENUM: Riesgo embarazo (FDA) ─────────────────────────────

@HiveType(typeId: 12)
enum RiesgoEmbarazo {
  @HiveField(0)
  A,

  @HiveField(1)
  B,

  @HiveField(2)
  C,

  @HiveField(3)
  D,

  @HiveField(4)
  X,

  @HiveField(5)
  desconocido,
}

// ─── MODELO PRINCIPAL ─────────────────────────────────────────

@HiveType(typeId: 10)
class FarmacoModel extends HiveObject {
  // Identificación
  @HiveField(0)
  final String nombre;

  @HiveField(1)
  final String subtitulo;

  @HiveField(2)
  final CategoriaFarmaco categoria;

  @HiveField(3)
  final List<String> rutas; // ["IV", "IM", "VO", "SC", "IO"]

  // Dosis
  @HiveField(4)
  final String dosisAdulto;

  @HiveField(5)
  final String dosisPediatrica;

  // Información clínica
  @HiveField(6)
  final String generalidades;

  // Compatibilidad IV
  @HiveField(7)
  final List<String> compatibles;

  @HiveField(8)
  final List<String> incompatibles;

  // Preparación
  @HiveField(9)
  final String preparacion;

  @HiveField(10)
  final String tiempoInfusion;

  // Embarazo
  @HiveField(11)
  final RiesgoEmbarazo categoriaEmbarazo;

  @HiveField(12)
  final String notaEmbarazo;

  // Efectos adversos
  @HiveField(13)
  final List<String> efectosGraves;

  @HiveField(14)
  final List<String> efectosFrecuentes;

  // ─────────────────────────────────────────────────────────────
  const FarmacoModel({
    required this.nombre,
    required this.subtitulo,
    required this.categoria,
    required this.rutas,
    required this.dosisAdulto,
    required this.dosisPediatrica,
    required this.generalidades,
    required this.compatibles,
    required this.incompatibles,
    required this.preparacion,
    required this.tiempoInfusion,
    required this.categoriaEmbarazo,
    required this.notaEmbarazo,
    required this.efectosGraves,
    required this.efectosFrecuentes,
  });

  // ─── COLORES CLÍNICOS POR CATEGORÍA ──────────────────────────
  //  Colores ajustados para mantener la estética médica/teal de la app.

  Color get colorFondo {
    switch (categoria) {
      case CategoriaFarmaco.analgesicos:
        return const Color(0xFFF0FDF4); // Verde muy suave
      case CategoriaFarmaco.antibioticos:
        return const Color(0xFFECFDF5);
      case CategoriaFarmaco.cardiovascular:
        return const Color(0xFFFEF2F2); // Rojo muy suave
      case CategoriaFarmaco.digestivos:
        return const Color(0xFFF5F3FF); // Morado muy suave
      case CategoriaFarmaco.anticoagulantes:
        return const Color(0xFFFFF1F2);
      case CategoriaFarmaco.esteroides:
        return const Color(0xFFEFF6FF); // Azul muy suave
      case CategoriaFarmaco.soluciones:
        return const Color(0xFFECFEFF);
      case CategoriaFarmaco.electrolitos:
        return const Color(0xFFFFFBEB); // Amarillo muy suave
      default:
        return const Color(0xFFF9FAFB);
    }
  }

  Color get colorPrincipal {
    switch (categoria) {
      case CategoriaFarmaco.analgesicos:
        return const Color(0xFF10B981); // Teal principal
      case CategoriaFarmaco.antibioticos:
        return const Color(0xFF059669);
      case CategoriaFarmaco.cardiovascular:
        return const Color(0xFFDC2626);
      case CategoriaFarmaco.digestivos:
        return const Color(0xFF7C3AED);
      case CategoriaFarmaco.anticoagulantes:
        return const Color(0xFFBE123C);
      case CategoriaFarmaco.esteroides:
        return const Color(0xFF2563EB);
      case CategoriaFarmaco.soluciones:
        return const Color(0xFF0891B2);
      case CategoriaFarmaco.electrolitos:
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
  }

  // Colores del distintivo de riesgo embarazo
  Color get colorEmbarazoFondo {
    switch (categoriaEmbarazo) {
      case RiesgoEmbarazo.A:
      case RiesgoEmbarazo.B:
        return const Color(0xFFDCFCE7);
      case RiesgoEmbarazo.C:
        return const Color(0xFFFEF3C7);
      case RiesgoEmbarazo.D:
        return const Color(0xFFFFEDD5);
      case RiesgoEmbarazo.X:
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get colorEmbarazoTexto {
    switch (categoriaEmbarazo) {
      case RiesgoEmbarazo.A:
      case RiesgoEmbarazo.B:
        return const Color(0xFF166534);
      case RiesgoEmbarazo.C:
        return const Color(0xFF92400E);
      case RiesgoEmbarazo.D:
        return const Color(0xFF9A3412);
      case RiesgoEmbarazo.X:
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF374151);
    }
  }

  String get etiquetaEmbarazo {
    if (categoriaEmbarazo == RiesgoEmbarazo.desconocido) return 'No clasificado';
    return 'Categoría ${categoriaEmbarazo.name.toUpperCase()} (FDA)';
  }

  // ─── SERIALIZACIÓN ───────────────────────────────────────────

  factory FarmacoModel.fromJson(Map<String, dynamic> json) {
    return FarmacoModel(
      nombre: json['nombre'] ?? '',
      subtitulo: json['subtitulo'] ?? '',
      categoria: _parsearCategoria(json['categoria'] ?? ''),
      rutas: List<String>.from(json['rutas'] ?? []),
      dosisAdulto: json['dosisAdulto'] ?? '',
      dosisPediatrica: json['dosisPediatrica'] ?? '',
      generalidades: json['generalidades'] ?? '',
      compatibles: List<String>.from(json['compatibles'] ?? json['compatibleCon'] ?? []),
      incompatibles: List<String>.from(json['incompatibles'] ?? json['incompatibleCon'] ?? []),
      preparacion: json['preparacion'] ?? '',
      tiempoInfusion: json['tiempoInfusion'] ?? '',
      categoriaEmbarazo: _parsearEmbarazo(json['categoriaEmbarazo'] ?? ''),
      notaEmbarazo: json['notaEmbarazo'] ?? json['embarazoTexto'] ?? '',
      efectosGraves: List<String>.from(json['efectosGraves'] ?? []),
      efectosFrecuentes: List<String>.from(json['efectosFrecuentes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'subtitulo': subtitulo,
      'categoria': categoria.name,
      'rutas': rutas,
      'dosisAdulto': dosisAdulto,
      'dosisPediatrica': dosisPediatrica,
      'generalidades': generalidades,
      'compatibles': compatibles,
      'incompatibles': incompatibles,
      'preparacion': preparacion,
      'tiempoInfusion': tiempoInfusion,
      'categoriaEmbarazo': categoriaEmbarazo.name,
      'notaEmbarazo': notaEmbarazo,
      'efectosGraves': efectosGraves,
      'efectosFrecuentes': efectosFrecuentes,
    };
  }

  // ─── HELPERS ─────────────────────────────────────────────────

  static CategoriaFarmaco _parsearCategoria(String valor) {
    final v = valor.toLowerCase().trim();
    if (v.contains('analgesico')) return CategoriaFarmaco.analgesicos;
    if (v.contains('antibiotico')) return CategoriaFarmaco.antibioticos;
    if (v.contains('cardio')) return CategoriaFarmaco.cardiovascular;
    if (v.contains('digest')) return CategoriaFarmaco.digestivos;
    if (v.contains('anticoag')) return CategoriaFarmaco.anticoagulantes;
    if (v.contains('esteroid')) return CategoriaFarmaco.esteroides;
    if (v.contains('solucion')) return CategoriaFarmaco.soluciones;
    if (v.contains('electrolit')) return CategoriaFarmaco.electrolitos;
    if (v.contains('endocrin')) return CategoriaFarmaco.endocrinologia;
    if (v.contains('neumo')) return CategoriaFarmaco.neumologia;
    if (v.contains('neuro')) return CategoriaFarmaco.neurologia;
    return CategoriaFarmaco.otros;
  }

  static RiesgoEmbarazo _parsearEmbarazo(String valor) {
    final v = valor.trim().toUpperCase();
    if (v.contains('A')) return RiesgoEmbarazo.A;
    if (v.contains('B')) return RiesgoEmbarazo.B;
    if (v.contains('C')) return RiesgoEmbarazo.C;
    if (v.contains('D')) return RiesgoEmbarazo.D;
    if (v.contains('X')) return RiesgoEmbarazo.X;
    return RiesgoEmbarazo.desconocido;
  }

  FarmacoModel copyWith({
    String? nombre,
    String? subtitulo,
    CategoriaFarmaco? categoria,
    List<String>? rutas,
    String? dosisAdulto,
    String? dosisPediatrica,
    String? generalidades,
    List<String>? compatibles,
    List<String>? incompatibles,
    String? preparacion,
    String? tiempoInfusion,
    RiesgoEmbarazo? categoriaEmbarazo,
    String? notaEmbarazo,
    List<String>? efectosGraves,
    List<String>? efectosFrecuentes,
  }) {
    return FarmacoModel(
      nombre: nombre ?? this.nombre,
      subtitulo: subtitulo ?? this.subtitulo,
      categoria: categoria ?? this.categoria,
      rutas: rutas ?? this.rutas,
      dosisAdulto: dosisAdulto ?? this.dosisAdulto,
      dosisPediatrica: dosisPediatrica ?? this.dosisPediatrica,
      generalidades: generalidades ?? this.generalidades,
      compatibles: compatibles ?? this.compatibles,
      incompatibles: incompatibles ?? this.incompatibles,
      preparacion: preparacion ?? this.preparacion,
      tiempoInfusion: tiempoInfusion ?? this.tiempoInfusion,
      categoriaEmbarazo: categoriaEmbarazo ?? this.categoriaEmbarazo,
      notaEmbarazo: notaEmbarazo ?? this.notaEmbarazo,
      efectosGraves: efectosGraves ?? this.efectosGraves,
      efectosFrecuentes: efectosFrecuentes ?? this.efectosFrecuentes,
    );
  }

  @override
  String toString() => 'FarmacoModel($nombre)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmacoModel &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre;

  @override
  int get hashCode => nombre.hashCode;
}
