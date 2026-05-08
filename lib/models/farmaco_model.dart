class Farmaco {
  final String nombre;
  final String categoria;
  final String grupo;
  final List<String> vias;
  final String dosisAdulto;
  final String dosisPediatrica;
  final List<String> compatibilidad;
  final String preparacion;
  final String dilucion;
  final String tiempoInfusion;
  final String riesgoEmbarazo;
  final List<String> efectosAdversos;
  final List<String> contraindicaciones;
  final String generalidades;

  Farmaco({
    required this.nombre,
    required this.categoria,
    required this.grupo,
    required this.vias,
    required this.dosisAdulto,
    required this.dosisPediatrica,
    required this.compatibilidad,
    required this.preparacion,
    required this.dilucion,
    required this.tiempoInfusion,
    required this.riesgoEmbarazo,
    required this.efectosAdversos,
    required this.contraindicaciones,
    required this.generalidades,
  });

  factory Farmaco.fromJson(Map<String, dynamic> json) {
    return Farmaco(
      nombre: json['nombre'] ?? '',
      categoria: json['categoria'] ?? '',
      grupo: json['grupo'] ?? '',
      vias: _parseList(json['vias']),
      dosisAdulto: json['dosisAdulto'] ?? '',
      dosisPediatrica: json['dosisPediatrica'] ?? '',
      compatibilidad: _parseList(json['compatibilidad']),
      preparacion: json['preparacion'] ?? '',
      dilucion: json['dilucion'] ?? '',
      tiempoInfusion: json['tiempoInfusion'] ?? '',
      riesgoEmbarazo: json['riesgoEmbarazo'] ?? '',
      efectosAdversos: _parseList(json['efectosAdversos']),
      contraindicaciones: _parseList(json['contraindicaciones']),
      generalidades: json['generalidades'] ?? '',
    );
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    if (value is String) return [value];
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'grupo': grupo,
      'vias': vias,
      'dosisAdulto': dosisAdulto,
      'dosisPediatrica': dosisPediatrica,
      'compatibilidad': compatibilidad,
      'preparacion': preparacion,
      'dilucion': dilucion,
      'tiempoInfusion': tiempoInfusion,
      'riesgoEmbarazo': riesgoEmbarazo,
      'efectosAdversos': efectosAdversos,
      'contraindicaciones': contraindicaciones,
      'generalidades': generalidades,
    };
  }
}
