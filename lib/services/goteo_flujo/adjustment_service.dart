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
      (timer) async {
        if (modoSensorial) {
          bool? hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 50); // Vibración corta de 50ms
          }
        }

        if (modoAuditivo) {
          // Limpieza de Memoria: liberamos el buffer antes de cada play()
          // permitiendo que el sonido se reinicie inmediatamente en cada pulso
          await _audioPlayer.stop();
          
          // Se reproduce el asset con la ruta correcta
          await _audioPlayer.play(AssetSource('audio/gota.mp3'));
        }
      },
    );
  }

  /// Cancela el Timer y detiene las reproducciones activas
  void detenerGuia() {
    _timer?.cancel();
    _timer = null;
    _audioPlayer.stop();
  }
}