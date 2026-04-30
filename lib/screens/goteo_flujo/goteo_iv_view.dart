import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/goteo_flujo/gote_iv_services.dart';
import '../../services/goteo_flujo/adjustment_service.dart';

class GoteoIVView extends StatefulWidget {
  const GoteoIVView({super.key});

  @override
  State<GoteoIVView> createState() => _GoteoIVViewState();
}

class _GoteoIVViewState extends State<GoteoIVView>
    with SingleTickerProviderStateMixin {
  // Controladores para los campos de texto
  final TextEditingController _volumenController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();

  // Variables de estado para las opciones
  bool _isHoras = true; // true = horas, false = minutos
  bool _isNormogotero = true; // true = normogotero, false = microgotero

  double _resultadoGotas = 0;
  double _resultadoMlHora = 0;

  // Variables para la guía de ajuste
  final AdjustmentService _adjustmentService = AdjustmentService();
  bool _isGuideActive = false;
  Timer? _visualTimer;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  // Mismo color primario utilizado en la calculadora maestra
  final Color _primaryBlue = const Color(0xFF0056D2);

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
    _volumenController.dispose();
    _tiempoController.dispose();
    super.dispose();
  }

  void _iniciarGuia() {
    final int intervalo =
        GoteoIvService.calcularIntervaloMilisegundos(_resultadoGotas);

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

  void _nuevoCalculo() {
    _detenerGuia();
    _volumenController.clear();
    _tiempoController.clear();
    setState(() {
      _resultadoGotas = 0;
      _resultadoMlHora = 0;
    });
  }

  // Widget de ayuda para mantener consistencia en las etiquetas
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151), // Gris oscuro
        ),
      ),
    );
  }

  // Widget de ayuda para los inputs de texto
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: BorderSide(color: _primaryBlue, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- SECCIÓN 1: VOLUMEN ---
          _buildLabel('Volumen a transfundir (ml)'),
          TextField(
            controller: _volumenController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _buildInputDecoration('Ej. 1000'),
          ),
          const SizedBox(height: 24),

          // --- SECCIÓN 2: TIEMPO Y UNIDAD ---
          _buildLabel('Tiempo de infusión'),
          Row(
            children: [
              // Input numérico del tiempo
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _tiempoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _buildInputDecoration('Ej. 8'),
                ),
              ),
              const SizedBox(width: 12),
              // Selector (Toggle) de Horas / Minutos
              Expanded(
                flex: 3,
                child: Container(
                  height: 52, // Alineado con la altura estándar del TextField
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isHoras = true),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  _isHoras ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isHoras
                                  ? [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Horas',
                              style: TextStyle(
                                fontWeight: _isHoras
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _isHoras
                                    ? _primaryBlue
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isHoras = false),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  !_isHoras ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !_isHoras
                                  ? [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Minutos',
                              style: TextStyle(
                                fontWeight: !_isHoras
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: !_isHoras
                                    ? _primaryBlue
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- SECCIÓN 3: TIPO DE EQUIPO ---
          _buildLabel('Tipo de equipo de goteo'),
          Row(
            children: [
              Expanded(
                child: _buildEquipoCard(
                  title: 'Normogotero',
                  subtitle: '20 gotas/ml',
                  isSelected: _isNormogotero,
                  onTap: () => setState(() => _isNormogotero = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEquipoCard(
                  title: 'Microgotero',
                  subtitle: '60 microgotas/ml',
                  isSelected: !_isNormogotero,
                  onTap: () => setState(() => _isNormogotero = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // --- SECCIÓN 4: BOTÓN CALCULAR ---
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context)
                  .unfocus(); // Ocultar el teclado al calcular
              _detenerGuia(); // Detener si estaba corriendo una guía previa

              final double volumen = double.tryParse(
                      _volumenController.text.replaceAll(',', '.')) ??
                  0;
              final double tiempo = double.tryParse(
                      _tiempoController.text.replaceAll(',', '.')) ??
                  0;

              if (volumen > 0 && tiempo > 0) {
                final int factorGoteo = _isNormogotero ? 20 : 60;

                setState(() {
                  _resultadoGotas = GoteoIvService.calcularGotasMin(
                    volumen: volumen,
                    tiempo: tiempo,
                    isHoras: _isHoras,
                    factorGoteo: factorGoteo,
                  );
                  _resultadoMlHora = GoteoIvService.calcularMlHora(
                    volumen: volumen,
                    tiempo: tiempo,
                    isHoras: _isHoras,
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Por favor, ingresa valores válidos mayores a 0.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
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

          // --- SECCIÓN 5: RESULTADOS ---
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
                          const Icon(Icons.water_drop_outlined,
                              color: Color(0xFF2E7D32), size: 40),
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
                      const SizedBox(height: 12),
                      Text(
                        'Flujo: ${_resultadoMlHora.toStringAsFixed(1)} ml/h',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _isGuideActive ? _detenerGuia() : _iniciarGuia(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isGuideActive
                                ? Colors.red.shade600
                                : const Color(
                                    0xFF8B5CF6), // Púrpura de la imagen
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    _isGuideActive
                                        ? Icons.stop
                                        : Icons.play_arrow,
                                    size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _isGuideActive
                                      ? 'Detener Guía de Ajuste'
                                      : 'Iniciar Guía de Ajuste',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.water_drop,
                                    size: 16, color: Colors.lightBlueAccent),
                                const SizedBox(width: 4),
                                const Icon(Icons.volume_up,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
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
                            side: const BorderSide(
                                color: Color(0xFF2E7D32), width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Nuevo Cálculo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }

  // Widget de ayuda para construir las tarjetas seleccionables de equipo
  Widget _buildEquipoCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? _primaryBlue.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.water_drop : Icons.water_drop_outlined,
              color: isSelected ? _primaryBlue : Colors.grey.shade400,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? _primaryBlue : const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? _primaryBlue.withValues(alpha: 0.8)
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
