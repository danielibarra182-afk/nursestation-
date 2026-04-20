class GoteoRealService {
  final List<int> _timestamps = [];

  void registrarGota() {
    _timestamps.add(DateTime.now().millisecondsSinceEpoch);
  }

  void reiniciar() {
    _timestamps.clear();
  }

  int get cantidadToques => _timestamps.length;

  bool get tieneSuficientesDatos => cantidadToques >= 3;

  double _calcularPromedioMilisegundos() {
    if (!tieneSuficientesDatos) return 0.0;

    int sumaDiferencias = 0;
    for (int i = 1; i < _timestamps.length; i++) {
      sumaDiferencias += (_timestamps[i] - _timestamps[i - 1]);
    }

    // Promedio de las diferencias
    return sumaDiferencias / (_timestamps.length - 1);
  }

  int calcularGotasPorMinuto() {
    final double promedioMs = _calcularPromedioMilisegundos();
    if (promedioMs <= 0) return 0;

    return (60000 / promedioMs).round();
  }

  double calcularMlPorHora(int factorEquipo) {
    int gotasMin = calcularGotasPorMinuto();
    return (gotasMin * 60) / factorEquipo;
  }
}
