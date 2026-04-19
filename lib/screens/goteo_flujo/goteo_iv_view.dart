import 'package:flutter/material.dart';

class GoteoIVView extends StatefulWidget {
  const GoteoIVView({super.key});

  @override
  State<GoteoIVView> createState() => _GoteoIVViewState();
}

class _GoteoIVViewState extends State<GoteoIVView> {
  // Controladores para los campos de texto
  final TextEditingController _volumenController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  
  // Variables de estado para las opciones
  bool _isHoras = true; // true = horas, false = minutos
  bool _isNormogotero = true; // true = normogotero, false = microgotero

  // Mismo color primario utilizado en la calculadora maestra
  final Color _primaryBlue = const Color(0xFF0056D2);

  @override
  void dispose() {
    _volumenController.dispose();
    _tiempoController.dispose();
    super.dispose();
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
            keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
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
                              color: _isHoras ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isHoras
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Horas',
                              style: TextStyle(
                                fontWeight: _isHoras ? FontWeight.bold : FontWeight.w500,
                                color: _isHoras ? _primaryBlue : Colors.grey.shade600,
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
                              color: !_isHoras ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !_isHoras
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Minutos',
                              style: TextStyle(
                                fontWeight: !_isHoras ? FontWeight.bold : FontWeight.w500,
                                color: !_isHoras ? _primaryBlue : Colors.grey.shade600,
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
              // TODO: Implementar lógica de cálculo
              FocusScope.of(context).unfocus(); // Ocultar el teclado al calcular
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
          color: isSelected ? _primaryBlue.withOpacity(0.05) : Colors.white,
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
                color: isSelected ? _primaryBlue.withOpacity(0.8) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
