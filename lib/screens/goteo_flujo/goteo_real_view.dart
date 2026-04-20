import 'package:flutter/material.dart';
import '../../services/goteo_flujo/goteo_real_services.dart';

class GoteoRealView extends StatefulWidget {
  const GoteoRealView({super.key});

  @override
  State<GoteoRealView> createState() => _GoteoRealViewState();
}

class _GoteoRealViewState extends State<GoteoRealView> {
  // Estado para el tipo de equipo (true = Macrogoteo, false = Microgoteo)
  bool _isMacrogoteo = true;
  
  // Servicio para el cálculo de goteo real
  final GoteoRealService _goteoRealService = GoteoRealService();

  // Color de atención para esta pantalla
  final Color _primaryTeal =
      const Color(0xFF008080); // turquesa oscuro según solicitud

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Contenedor Principal
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // Sombra suave
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título de Sección
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.colorize, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 12),
                    const Text(
                      'Medir Goteo Real',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366), // Color texto oscuro clínico
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Instrucciones
                const Text(
                  'Presiona el botón cada vez que veas caer una gota para medir la velocidad real del goteo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Selector de Equipo (Tarjetas)
                const Text(
                  'Tipo de Equipo de Goteo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildEquipoCard(
                        dropFactor: '20',
                        description: 'gotas/mL Macrogoteo',
                        isSelected: _isMacrogoteo,
                        onTap: () => setState(() => _isMacrogoteo = true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildEquipoCard(
                        dropFactor: '60',
                        description: 'gotas/mL Microgoteo',
                        isSelected: !_isMacrogoteo,
                        onTap: () => setState(() => _isMacrogoteo = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Botón de Acción Grande
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _goteoRealService.registrarGota();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.water_drop, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        _goteoRealService.cantidadToques == 0
                            ? 'Presionar al ver gota'
                            : 'Presionar al ver gota (${_goteoRealService.cantidadToques})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (!_goteoRealService.tieneSuficientesDatos && _goteoRealService.cantidadToques > 0)
                  Text(
                    '${_goteoRealService.cantidadToques} toque${_goteoRealService.cantidadToques == 1 ? '' : 's'} (Mínimo 3 para calcular)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (_goteoRealService.tieneSuficientesDatos)
                  _buildResultPanel(),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Notas Informativas
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Toca el botón al ritmo exacto de las gotas para obtener\nmediciones precisas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'El sistema promedia automáticamente tus mediciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipoCard({
    required String dropFactor,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    List<String> descParts = description.split(' ');
    String unit = descParts[0]; // gotas/mL
    String type = descParts[1]; // Macrogoteo o Microgoteo

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryTeal.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryTeal : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dropFactor,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isSelected ? _primaryTeal : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? _primaryTeal : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? _primaryTeal.withOpacity(0.8)
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

  Widget _buildResultPanel() {
    int factorEquipo = _isMacrogoteo ? 20 : 60;
    int gotasMin = _goteoRealService.calcularGotasPorMinuto();
    double mlHora = _goteoRealService.calcularMlPorHora(factorEquipo);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primaryTeal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryTeal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Medición Actual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildResultItem(Icons.water_drop, '$gotasMin', 'gotas/min'),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade300,
              ),
              _buildResultItem(Icons.speed, mlHora.toStringAsFixed(1), 'mL/h'),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _goteoRealService.reiniciar();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar Medición'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primaryTeal,
              side: BorderSide(color: _primaryTeal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultItem(IconData icon, String value, String unit) {
    return Column(
      children: [
        Icon(icon, color: _primaryTeal, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _primaryTeal,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
