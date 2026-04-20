class GoteoIvService {
  /// Calcula las gotas por minuto
  static double calcularGotasMin({
    required double volumen,
    required double tiempo,
    required bool isHoras,
    required int factorGoteo,
  }) {
    if (tiempo <= 0) return 0; // Prevenir división por cero

    double tiempoEnMinutos = isHoras ? tiempo * 60 : tiempo;
    return (volumen * factorGoteo) / tiempoEnMinutos;
  }

  /// Calcula los mililitros por hora (flujo)
  static double calcularMlHora({
    required double volumen,
    required double tiempo,
    required bool isHoras,
  }) {
    if (tiempo <= 0) return 0; // Prevenir división por cero

    double tiempoEnHoras = isHoras ? tiempo : tiempo / 60;
    return volumen / tiempoEnHoras;
  }

  /// Calcula las gotas por minuto partiendo de una velocidad de flujo (mL/hora)
  static double calcularGotasDesdeFlujo({
    required double mlHora,
    required int factorGoteo,
  }) {
    if (mlHora <= 0) return 0;
    return (mlHora * factorGoteo) / 60.0;
  }

  /// Convierte las gotas por minuto en el intervalo en milisegundos entre cada gota
  static int calcularIntervaloMilisegundos(double gotasMin) {
    if (gotasMin <= 0) return 0; // Prevenir división por cero o negativa
    return (60000 / gotasMin).round();
  }
}