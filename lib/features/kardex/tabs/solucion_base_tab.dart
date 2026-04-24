import 'package:flutter/material.dart';
import '../widgets/custom_kardex_input.dart';
import '../../../services/kardex/kardex_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';

class SolucionBaseTab extends StatefulWidget {
  final String pacienteId;

  const SolucionBaseTab({super.key, required this.pacienteId});

  @override
  State<SolucionBaseTab> createState() => _SolucionBaseTabState();
}

class _SolucionBaseTabState extends State<SolucionBaseTab> {
  String _tiempoSeleccionado = '8 horas';
  
  final _nombreController = TextEditingController();
  final _volumenController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _volumenController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    final volumenText = _volumenController.text.trim();

    if (nombre.isEmpty || volumenText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    final double volumen = double.tryParse(volumenText) ?? 0.0;
    final int horas = int.tryParse(_tiempoSeleccionado.split(' ')[0]) ?? 8;
    
    final double mlPorHora = horas > 0 ? volumen / horas : 0.0;
    final double gotasPorMin = mlPorHora / 3;

    final datos = {
      'nombre': nombre,
      'volumen': volumen,
      'tiempo': _tiempoSeleccionado,
      'ml_h': mlPorHora.toStringAsFixed(1),
      'gotas_min': gotasPorMin.toStringAsFixed(0),
      'fecha': DateTime.now().toIso8601String(),
    };

    await KardexService().guardarSolucionBase(
      pacienteId: widget.pacienteId,
      datos: datos,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solución guardada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _nombreController.clear();
      _volumenController.clear();
      setState(() {
        _tiempoSeleccionado = '8 horas';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // Light blue background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.water_drop_outlined, color: Color(0xFF3B82F6), size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solución Base',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      'Configuración de hidratación principal',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nombre de la solución
            CustomKardexInput(
              icon: Icons.medication_liquid_outlined,
              label: 'Nombre de la solución',
              hintText: 'Ej: Solución salina 0.9%',
              controller: _nombreController,
            ),
            const SizedBox(height: 16),

            // Volumen and Tiempo Row
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomKardexInput(
                        icon: Icons.water_drop_outlined,
                        label: 'Volumen (mL)',
                        hintText: '1000',
                        controller: _volumenController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiempo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _tiempoSeleccionado,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                            items: ['8 horas', '12 horas', '24 horas']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF111827))),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _tiempoSeleccionado = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Botón Agregar solución
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB), // Color azul primario
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Guardar Solución Base',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Soluciones Guardadas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildListaSoluciones(),
          ],
        ),
      ),
    );
  }

  Widget _buildListaSoluciones() {
    var box = Hive.box('pacientes');
    PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
    
    if (paciente == null) {
      try {
        paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
      } catch (e) {}
    }

    final soluciones = paciente?.solucionesBase ?? [];

    if (soluciones.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No hay soluciones guardadas.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: soluciones.length,
      itemBuilder: (context, index) {
        final sol = soluciones[soluciones.length - 1 - index] as Map<dynamic, dynamic>;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.vaccines, color: Color(0xFF3B82F6), size: 20),
            ),
            title: Text(
              '${sol['nombre']} - ${sol['volumen']} mL',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Ritmo: ${sol['ml_h']} ml/h | ${sol['gotas_min']} gotas/min\nTiempo: ${sol['tiempo']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ),
        );
      },
    );
  }
}

