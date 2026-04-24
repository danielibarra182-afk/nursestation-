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
  bool _mostrarFormulario = true;
  
  final _nombreController = TextEditingController();
  final _volumenController = TextEditingController();
  final _tiempoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  void _checkInitialState() {
    var box = Hive.box('pacientes');
    PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
    if (paciente == null) {
      try {
        paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
      } catch (e) {}
    }
    
    final soluciones = paciente?.solucionesBase ?? [];
    if (soluciones.isNotEmpty) {
      _mostrarFormulario = false;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _volumenController.dispose();
    _tiempoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    final volumenText = _volumenController.text.trim();
    final tiempoText = _tiempoController.text.trim();

    if (nombre.isEmpty || volumenText.isEmpty || tiempoText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    final double volumen = double.tryParse(volumenText) ?? 0.0;
    final int horas = int.tryParse(tiempoText) ?? 0;
    
    final double mlPorHora = horas > 0 ? volumen / horas : 0.0;
    final double gotasPorMin = mlPorHora / 3;

    final datos = {
      'nombre': nombre,
      'volumen': volumen,
      'tiempo': '${horas}h',
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
      _tiempoController.clear();
      setState(() {
        _mostrarFormulario = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('pacientes').listenable(),
      builder: (context, Box box, child) {
        PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
        if (paciente == null) {
          try {
            paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
          } catch (e) {}
        }
        
        final soluciones = paciente?.solucionesBase ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (soluciones.isNotEmpty) ...[
                const Text(
                  'Soluciones registradas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                _buildListaSoluciones(soluciones),
                const SizedBox(height: 16),
              ],
              
              if (_mostrarFormulario)
                _buildFormulario()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB), // Color azul primario
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Agregar solución',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormulario() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              Expanded(
                child: Column(
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
              ),
              if (Hive.box('pacientes').get(widget.pacienteId) != null && 
                 ((Hive.box('pacientes').get(widget.pacienteId) as PatientModel).solucionesBase?.isNotEmpty ?? false))
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _mostrarFormulario = false;
                    });
                  },
                )
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
                    CustomKardexInput(
                      icon: Icons.timer_outlined,
                      label: 'Tiempo (horas)',
                      hintText: 'Ej: 8',
                      controller: _tiempoController,
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
        ],
      ),
    );
  }

  Widget _buildListaSoluciones(List<dynamic> soluciones) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: soluciones.length,
      itemBuilder: (context, index) {
        final solIndex = soluciones.length - 1 - index;
        final sol = soluciones[solIndex] as Map<dynamic, dynamic>;
        
        String fechaMostrada = '';
        if (sol['fecha'] != null) {
          try {
            final dt = DateTime.parse(sol['fecha']);
            fechaMostrada = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
          } catch (e) {
            fechaMostrada = sol['fecha'];
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila Superior
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF), // Fondo azul suave
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.water_drop_outlined, color: Color(0xFF3B82F6), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sol['nombre']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fechaMostrada,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () async {
                      // Eliminar la solución (opcional pero funcional)
                      var box = Hive.box('pacientes');
                      PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
                      if (paciente == null) {
                        try {
                          paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
                        } catch (e) {}
                      }
                      if (paciente != null) {
                        final lista = List<dynamic>.from(paciente.solucionesBase ?? []);
                        lista.removeAt(solIndex);
                        paciente.solucionesBase = lista;
                        if (paciente.isInBox) {
                          await paciente.save();
                        } else if (paciente.key != null) {
                          await box.put(paciente.key, paciente);
                        }
                      }
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Fila Media (Volumen y Tiempo)
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Volumen: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        children: [
                          TextSpan(
                            text: '${sol['volumen']} mL',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Tiempo: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        children: [
                          TextSpan(
                            text: sol['tiempo']?.toString().replaceAll(' horas', 'h') ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Equipo: ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  children: const [
                    TextSpan(
                      text: 'Normogotero',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Sección de Cálculos
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // KardexStyle.grisCampo o similar
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Gotas/minuto',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sol['gotas_min']?.toString() ?? '0',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0CA79E), // Mismo azul turquesa de la app
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'mL/hora',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sol['ml_h']?.toString() ?? '0',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0CA79E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
