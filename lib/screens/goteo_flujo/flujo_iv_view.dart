import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/goteo_flujo/gote_iv_services.dart';
import '../../services/goteo_flujo/adjustment_service.dart';

class FlujoIVView extends StatefulWidget {
  const FlujoIVView({super.key});

  @override
  State<FlujoIVView> createState() => _FlujoIVViewState();
}

class _FlujoIVViewState extends State<FlujoIVView> with SingleTickerProviderStateMixin {
  // Controladores
  final TextEditingController _velocidadController = TextEditingController();

  // Estado
  bool _isNormogotero = true;
  double _resultadoGotas = 0;
  bool _isGuideActive = false;

  // Variables para la guía de ajuste
  final AdjustmentService _adjustmentService = AdjustmentService();
  Timer? _visualTimer;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  // Color de la marca (Verde Esmeralda/Clínico)
  final Color _primaryGreen = const Color(
      0xFF008F39); // Un verde intenso similar a la imagen (#008F39 o #2E7D32)

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _colorAnimation = ColorTween(
      begin: Colors.green.shade50,
      end: Colors.green.shade300, // Color verde más intenso al ritmo del goteo
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _detenerGuia();
    _animationController.dispose();
    _velocidadController.dispose();
    super.dispose();
  }

  void _iniciarGuia() {
    final int intervalo = GoteoIvService.calcularIntervaloMilisegundos(_resultadoGotas);
    
    _adjustmentService.iniciarGuia(
      intervalo,
      modoSensorial: true,
      modoAuditivo: true,
    );

    setState(() {
      _isGuideActive = true;
    });

    _visualTimer = Timer.periodic(Duration(milliseconds: intervalo), (timer) {
      if (!mounted) return;
      _animationController.forward().then((_) {
        if (mounted) _animationController.reverse();
      });
    });
  }

  void _detenerGuia() {
    _adjustmentService.detenerGuia();
    _visualTimer?.cancel();
    if (mounted) {
      setState(() {
        _isGuideActive = false;
      });
      _animationController.reset();
    }
  }

  void _calcular() {
    FocusScope.of(context).unfocus();
    _detenerGuia(); // Detener si estaba corriendo una guía previa

    final double velocidad =
        double.tryParse(_velocidadController.text.replaceAll(',', '.')) ?? 0;

    if (velocidad > 0) {
      setState(() {
        final int factorGoteo = _isNormogotero ? 20 : 60;
        _resultadoGotas = GoteoIvService.calcularGotasDesdeFlujo(
          mlHora: velocidad,
          factorGoteo: factorGoteo,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa una velocidad válida mayor a 0.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _nuevoCalculo() {
    _detenerGuia();
    _velocidadController.clear();
    setState(() {
      _resultadoGotas = 0;
    });
  }

  Widget _buildLabel(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: _primaryGreen, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el color #2E7D32 también como una buena alternativa verde oscuro
    final Color actualGreen = Colors.green.shade700;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // VELOCIDAD DE FLUJO
            _buildLabel('Velocidad de Flujo (mL/h)', Icons.opacity),
            TextField(
              controller: _velocidadController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Ej. 125',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: actualGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingresa la velocidad de infusión programada',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            const SizedBox(height: 24),

            // TIPO DE EQUIPO DE GOTEO
            _buildLabel(
                'Tipo de Equipo de Goteo', Icons.monitor_heart_outlined),
            Row(
              children: [
                Expanded(
                  child: _buildEquipoCard(
                    numero: '20',
                    subtexto: 'gotas/mL',
                    tipo: 'Macrogotero',
                    isSelected: _isNormogotero,
                    color: actualGreen,
                    onTap: () => setState(() => _isNormogotero = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEquipoCard(
                    numero: '60',
                    subtexto: 'gotas/mL',
                    tipo: 'Microgotero',
                    isSelected: !_isNormogotero,
                    color: actualGreen,
                    onTap: () => setState(() => _isNormogotero = false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // BOTÓN CALCULAR
            ElevatedButton(
              onPressed: _calcular,
              style: ElevatedButton.styleFrom(
                backgroundColor: actualGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Calcular',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // RESULTADOS
            if (_resultadoGotas > 0) ...[
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _colorAnimation.value,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Gotas / min',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop_outlined, color: Color(0xFF2E7D32), size: 40),
                            const SizedBox(width: 8),
                            Text(
                              _resultadoGotas.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _isGuideActive ? _detenerGuia() : _iniciarGuia(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isGuideActive ? Colors.red.shade600 : const Color(0xFF8B5CF6), // Púrpura de la imagen
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_isGuideActive ? Icons.stop : Icons.play_arrow, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _isGuideActive ? 'Detener Guía de Ajuste' : 'Iniciar Guía de Ajuste',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.water_drop, size: 16, color: Colors.lightBlueAccent),
                                const SizedBox(width: 4),
                                const Icon(Icons.volume_up, size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _nuevoCalculo,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2E7D32),
                              side: const BorderSide(color: Color(0xFF2E7D32), width: 1),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Nuevo Cálculo',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEquipoCard({
    required String numero,
    required String subtexto,
    required String tipo,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          // Fondo verde muy claro si está seleccionado
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              numero,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: isSelected ? color : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subtexto,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    tipo,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? color.withValues(alpha: 0.8)
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

