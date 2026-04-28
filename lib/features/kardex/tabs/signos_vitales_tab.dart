import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';
import '../../../services/kardex/kardex_service.dart';
import '../widgets/custom_kardex_input.dart';
import '../widgets/kardex_style.dart';

class SignosVitalesTab extends StatefulWidget {
  final String pacienteId;
  const SignosVitalesTab({super.key, required this.pacienteId});

  @override
  State<SignosVitalesTab> createState() => _SignosVitalesTabState();
}

class _SignosVitalesTabState extends State<SignosVitalesTab> {
  bool _mostrarFormulario = false;
  String? _editandoId;
  String? _fechaOriginal;

  final TextEditingController _taController = TextEditingController();
  final TextEditingController _fcController = TextEditingController();
  final TextEditingController _frController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _spo2Controller = TextEditingController();
  final TextEditingController _glucosaController = TextEditingController();

  @override
  void dispose() {
    _taController.dispose();
    _fcController.dispose();
    _frController.dispose();
    _tempController.dispose();
    _spo2Controller.dispose();
    _glucosaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('pacientes').listenable(),
      builder: (context, box, child) {
        PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
        if (paciente == null) {
          try {
            paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
          } catch (e) {}
        }
        
        final signosLista = List<dynamic>.from(paciente?.signosVitales ?? []).reversed.toList();

        if (_mostrarFormulario) {
          return _buildFormState();
        }
        
        if (signosLista.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildListaState(signosLista);
      },
    );
  }

  void _abrirFormulario([dynamic signo]) {
    setState(() {
      _mostrarFormulario = true;
      if (signo != null) {
        _editandoId = signo['id'];
        _fechaOriginal = signo['fecha'];
        _taController.text = signo['ta']?.toString() ?? '';
        _fcController.text = signo['fc']?.toString() ?? '';
        _frController.text = signo['fr']?.toString() ?? '';
        _tempController.text = signo['temp']?.toString() ?? '';
        _spo2Controller.text = signo['spo2']?.toString() ?? '';
        _glucosaController.text = signo['glucosa']?.toString() ?? '';
      } else {
        _editandoId = null;
        _fechaOriginal = null;
        _taController.clear();
        _fcController.clear();
        _frController.clear();
        _tempController.clear();
        _spo2Controller.clear();
        _glucosaController.clear();
      }
    });
  }

  Future<void> _guardarSignos() async {
    final datos = {
      'id': _editandoId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'fecha': _fechaOriginal ?? DateTime.now().toIso8601String(),
      'ta': _taController.text.trim(),
      'fc': _fcController.text.trim(),
      'fr': _frController.text.trim(),
      'temp': _tempController.text.trim(),
      'spo2': _spo2Controller.text.trim(),
      'glucosa': _glucosaController.text.trim(),
    };

    if (_editandoId == null) {
      await KardexService().guardarSignosVitales(
        pacienteId: widget.pacienteId,
        datos: datos,
      );
    } else {
      await KardexService().actualizarSignosVitales(
        pacienteId: widget.pacienteId,
        signosActualizados: datos,
      );
    }

    if (mounted) {
      setState(() {
        _mostrarFormulario = false;
        _taController.clear();
        _fcController.clear();
        _frController.clear();
        _tempController.clear();
        _spo2Controller.clear();
        _glucosaController.clear();
        _editandoId = null;
        _fechaOriginal = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signos vitales registrados')),
      );
    }
  }

  Color _evaluarRango(String tipo, String valorOriginal) {
    if (valorOriginal.isEmpty) return KardexStyle.verdeMedico;

    final valStr = valorOriginal.replaceAll(RegExp(r'[^0-9.]'), '');
    final double? valor = double.tryParse(valStr);
    
    if (tipo == 'TA') {
      final partes = valorOriginal.split('/');
      if (partes.length == 2) {
        final sis = double.tryParse(partes[0].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        final dia = double.tryParse(partes[1].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        if (sis >= 90 && sis <= 120 && dia >= 60 && dia <= 80) {
          return KardexStyle.verdeMedico;
        }
        return Colors.amber[600]!;
      }
      return Colors.amber[600]!;
    }

    if (valor == null) return Colors.amber[600]!;

    switch (tipo) {
      case 'FC':
        if (valor >= 60 && valor <= 100) return KardexStyle.verdeMedico;
        break;
      case 'FR':
        if (valor >= 12 && valor <= 20) return KardexStyle.verdeMedico;
        break;
      case 'Temp':
        if (valor >= 36.5 && valor <= 37.5) return KardexStyle.verdeMedico;
        break;
      case 'SpO2':
        if (valor >= 95 && valor <= 100) return KardexStyle.verdeMedico;
        break;
      case 'Glucosa':
        if (valor >= 70 && valor <= 110) return KardexStyle.verdeMedico;
        break;
    }
    return Colors.amber[600]!;
  }

  Widget _buildListaState(List<dynamic> signos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Registros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('Nuevo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KardexStyle.verdeMedico,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: signos.length,
            itemBuilder: (context, index) {
              final val = signos[index];
              return _buildSignoCard(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignoCard(dynamic val) {
    String fechaStr = val['fecha'] ?? '';
    if (fechaStr.length > 16) {
      final dt = DateTime.tryParse(fechaStr);
      if (dt != null) {
        fechaStr = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    return Dismissible(
      key: Key(val['id']?.toString() ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Eliminar Registro"),
              content: const Text("¿Estás seguro de eliminar este registro de signos vitales?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        KardexService().eliminarSignosVitales(
          pacienteId: widget.pacienteId,
          signoId: val['id'],
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fechaStr,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFF9CA3AF)),
                  onPressed: () => _abrirFormulario(val),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                _buildSignoChip('TA', val['ta']?.toString() ?? '', 'mmHg'),
                _buildSignoChip('FC', val['fc']?.toString() ?? '', 'lpm'),
                _buildSignoChip('FR', val['fr']?.toString() ?? '', 'rpm'),
                _buildSignoChip('Temp', val['temp']?.toString() ?? '', '°C'),
                _buildSignoChip('SpO2', val['spo2']?.toString() ?? '', '%'),
                _buildSignoChip('Glucosa', val['glucosa']?.toString() ?? '', 'mg/dL'),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSignoChip(String tipo, String valor, String unidad) {
    if (valor.isEmpty || valor == '-') return const SizedBox.shrink();
    
    final color = _evaluarRango(tipo, valor);
    
    return Container(
      width: 100, // Fijamos ancho para que parezcan cajitas ordenadas
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            tipo,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unidad,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.show_chart,
                  size: 40,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No hay signos vitales registrados',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Registrar signos vitales',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KardexStyle.verdeMedico,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _editandoId == null ? 'Registrar signos vitales' : 'Editar signos vitales',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _mostrarFormulario = false;
                      _editandoId = null;
                      _fechaOriginal = null;
                    });
                  },
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280), size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),

            CustomKardexInput(
              controller: _taController,
              icon: Icons.show_chart,
              label: 'Presión arterial (mmHg)',
              hintText: 'Ej: 120/80',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            CustomKardexInput(
              controller: _fcController,
              icon: Icons.favorite_border,
              label: 'Frecuencia cardíaca (lpm)',
              hintText: 'Ej: 75',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            CustomKardexInput(
              controller: _tempController,
              icon: Icons.device_thermostat,
              label: 'Temperatura (°C)',
              hintText: 'Ej: 36.5',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            CustomKardexInput(
              controller: _frController,
              icon: Icons.show_chart,
              label: 'Frecuencia respiratoria (rpm)',
              hintText: 'Ej: 18',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            CustomKardexInput(
              controller: _spo2Controller,
              icon: Icons.show_chart,
              label: 'Saturación de oxígeno (%)',
              hintText: 'Ej: 98',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            CustomKardexInput(
              controller: _glucosaController,
              icon: Icons.water_drop,
              label: 'Glucometría (mg/dL)',
              hintText: 'Ej: 90',
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 32),

            // Botones de Acción
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = false;
                        _editandoId = null;
                        _fechaOriginal = null;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9), // Gris clarito
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_taController.text.isEmpty && _fcController.text.isEmpty && 
                          _frController.text.isEmpty && _tempController.text.isEmpty && 
                          _spo2Controller.text.isEmpty && _glucosaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ingresa al menos un valor')),
                        );
                        return;
                      }
                      _guardarSignos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63), // Rosa vibrante
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _editandoId == null ? 'Registrar' : 'Actualizar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
