class Farmaco {
  final String nombre;
  final String categoria;
  final String grupo;
  final List<String> vias;
  final String dosisAdulto;
  final String dosisPediatrica;
  final List<String> compatibleCon;
  final List<String> incompatibleCon;
  final List<String> efectosGraves;
  final List<String> efectosFrecuentes;
  final String preparacionBolus;
  final String dilucionBolus;
  final String tiempoBolus;
  final String preparacionInfusion;
  final String dilucionInfusion;
  final String tiempoInfusion;
  final String riesgoEmbarazo;
  final List<String> contraindicaciones;
  final String generalidades;

  Farmaco({
    required this.nombre,
    required this.categoria,
    required this.grupo,
    required this.vias,
    required this.dosisAdulto,
    required this.dosisPediatrica,
    required this.compatibleCon,
    required this.incompatibleCon,
    required this.efectosGraves,
    required this.efectosFrecuentes,
    required this.preparacionBolus,
    required this.dilucionBolus,
    required this.tiempoBolus,
    required this.preparacionInfusion,
    required this.dilucionInfusion,
    required this.tiempoInfusion,
    required this.riesgoEmbarazo,
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
      compatibleCon:
          _parseList(json['compatibleCon'] ?? json['compatibilidad']),
      incompatibleCon:
          _parseList(json['incompatibleCon'] ?? json['incompatibilidad']),
      efectosGraves: _parseList(json['efectosGraves']),
      efectosFrecuentes:
          _parseList(json['efectosFrecuentes'] ?? json['efectosAdversos']),
      preparacionBolus: json['preparacionBolus'] ?? '',
      dilucionBolus: json['dilucionBolus'] ?? '',
      tiempoBolus: json['tiempoBolus'] ?? '',
      preparacionInfusion:
          json['preparacionInfusion'] ?? json['preparacion'] ?? '',
      dilucionInfusion: json['dilucionInfusion'] ?? json['dilucion'] ?? '',
      tiempoInfusion: json['tiempoInfusion'] ?? '',
      riesgoEmbarazo: json['riesgoEmbarazo'] ?? '',
      contraindicaciones: _parseList(json['contraindicaciones']),
      generalidades: json['generalidades'] ?? '',
    );
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    if (value is String) {
      if (value.contains(',')) {
        return value
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [value];
    }
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
      'compatibleCon': compatibleCon,
      'incompatibleCon': incompatibleCon,
      'efectosGraves': efectosGraves,
      'efectosFrecuentes': efectosFrecuentes,
      'preparacionBolus': preparacionBolus,
      'dilucionBolus': dilucionBolus,
      'tiempoBolus': tiempoBolus,
      'preparacionInfusion': preparacionInfusion,
      'dilucionInfusion': dilucionInfusion,
      'tiempoInfusion': tiempoInfusion,
      'riesgoEmbarazo': riesgoEmbarazo,
      'contraindicaciones': contraindicaciones,
      'generalidades': generalidades,
    };
  }
}
