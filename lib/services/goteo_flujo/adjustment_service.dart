import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class AdjustmentService {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AdjustmentService() {
    // Modo de baja latencia para que el sonido sea instantáneo y no se desfase
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  bool? _hasVibrator;

  /// Inicia la guía con el intervalo en milisegundos calculado
  void iniciarGuia(
    int intervaloMilisegundos, {
    bool modoSensorial = true,
    bool modoAuditivo = true,
  }) {
    // Detenemos cualquier timer activo antes de iniciar uno nuevo
    detenerGuia();

    if (intervaloMilisegundos <= 0) return;

    _timer = Timer.periodic(
      Duration(milliseconds: intervaloMilisegundos),
      (timer) {
        if (modoSensorial) {
          _vibrate();
        }

        if (modoAuditivo) {
          _playSound();
        }
      },
    );
  }

  Future<void> _vibrate() async {
    _hasVibrator ??= await Vibration.hasVibrator();
    if (_hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }
  }

  Future<void> _playSound() async {
    // No esperamos (await) el stop/play para no bloquear el siguiente pulso del timer
    _audioPlayer.stop().then((_) {
      _audioPlayer.play(AssetSource('audio/gota.mp3'));
    });
  }

  /// Cancela el Timer y detiene las reproducciones activas
  void detenerGuia() {
    _timer?.cancel();
    _timer = null;
    _audioPlayer.stop();
  }
}