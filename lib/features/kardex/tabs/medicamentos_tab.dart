import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';
import '../../../services/kardex/kardex_service.dart';
import '../widgets/kardex_style.dart';
import '../widgets/custom_kardex_input.dart';

class MedicamentosTab extends StatefulWidget {
  final String pacienteId;
  const MedicamentosTab({super.key, required this.pacienteId});

  @override
  State<MedicamentosTab> createState() => _MedicamentosTabState();
}

class _MedicamentosTabState extends State<MedicamentosTab> {
  bool _mostrarFormulario = false;
  String? _editandoId;
  final KardexService _kardexService = KardexService();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _viaController =
      TextEditingController(text: 'Intravenosa (IV)');

  List<String> _horariosList = [];

  bool get _isValid {
    return _nombreController.text.trim().isNotEmpty && _horariosList.isNotEmpty;
  }

  void _abrirFormulario([dynamic med]) {
    setState(() {
      _mostrarFormulario = true;
      if (med != null) {
        _editandoId = med['id'];
        _nombreController.text = med['nombre'] ?? '';
        _dosisController.text = med['dosis'] ?? '';
        _viaController.text = med['via'] ?? 'Intravenosa (IV)';
        _horariosList = List<String>.from(med['horarios'] ?? []);
      } else {
        _editandoId = null;
        _nombreController.clear();
        _dosisController.clear();
        _viaController.text = 'Intravenosa (IV)';
        _horariosList.clear();
      }
    });
  }

  void _agregarHorario() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: KardexStyle.verdeMedico,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final hr = time.hour.toString().padLeft(2, '0');
      final min = time.minute.toString().padLeft(2, '0');
      setState(() {
        _horariosList.add('$hr:$min');
      });
    }
  }

  Future<void> _registrarMedicamento() async {
    if (!_isValid) return;

    if (_editandoId != null) {
      // Find the existing to preserve administrados
      var box = Hive.box('pacientes');
      PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
      List<String> administrados = [];
      String fechaRegistro = DateTime.now().toIso8601String();

      if (paciente != null) {
        final meds = List<dynamic>.from(paciente.medicamentos ?? []);
        final med = meds.firstWhere((m) => m['id'] == _editandoId, orElse: () => null);
        if (med != null) {
          administrados = List<String>.from(med['administrados'] ?? []);
          fechaRegistro = med['fecha_registro'] ?? fechaRegistro;
        }
      }

      final data = {
        'id': _editandoId,
        'nombre': _nombreController.text.trim(),
        'dosis': _dosisController.text.trim(),
        'via': _viaController.text.trim(),
        'horarios': List<String>.from(_horariosList),
        'administrados': administrados,
        'fecha_registro': fechaRegistro,
      };

      await _kardexService.actualizarMedicamento(
        pacienteId: widget.pacienteId,
        medicamentoActualizado: data,
      );
    } else {
      final data = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'nombre': _nombreController.text.trim(),
        'dosis': _dosisController.text.trim(),
        'via': _viaController.text.trim(),
        'horarios': List<String>.from(_horariosList),
        'fecha_registro': DateTime.now().toIso8601String(),
      };

      await _kardexService.guardarMedicamento(
        pacienteId: widget.pacienteId,
        datos: data,
      );
    }

    setState(() {
      _mostrarFormulario = false;
      _editandoId = null;
      _nombreController.clear();
      _dosisController.clear();
      _viaController.text = 'Intravenosa (IV)';
      _horariosList.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editandoId != null ? 'Medicamento actualizado exitosamente' : 'Medicamento registrado exitosamente'),
          backgroundColor: KardexStyle.verdeMedico,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nombreController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _dosisController.dispose();
    _viaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('pacientes').listenable(),
      builder: (context, box, child) {
        if (_mostrarFormulario) return _buildFormState();

        final paciente = box.get(widget.pacienteId) as PatientModel?;
        if (paciente == null) return _buildEmptyState();

        final medicamentosLista =
            List<dynamic>.from(paciente.medicamentos ?? []);
        if (medicamentosLista.isEmpty) {
          return _buildEmptyState();
        }

        final now = DateTime.now();
        final currentTime = now.hour * 60 + now.minute;

        int getClosestFutureTime(List<dynamic> horarios) {
          if (horarios.isEmpty) return 99999;

          List<int> futureTimes = [];
          List<int> allTimes = [];
          for (var h in horarios) {
            final parts = h.toString().split(':');
            if (parts.length == 2) {
              final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
              allTimes.add(minutes);
              if (minutes >= currentTime) {
                futureTimes.add(minutes);
              }
            }
          }

          if (futureTimes.isNotEmpty) {
            futureTimes.sort();
            return futureTimes.first;
          }

          if (allTimes.isNotEmpty) {
            allTimes.sort();
            return allTimes.first + 24 * 60; // Día siguiente
          }

          return 99999;
        }

        medicamentosLista.sort((a, b) {
          final horariosA = List<dynamic>.from(a['horarios'] ?? []);
          final horariosB = List<dynamic>.from(b['horarios'] ?? []);
          final closestA = getClosestFutureTime(horariosA);
          final closestB = getClosestFutureTime(horariosB);
          return closestA.compareTo(closestB);
        });

        return _buildMedicamentosList(medicamentosLista);
      },
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
              color: Colors.black.withValues(alpha: 0.03),
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
                decoration: BoxDecoration(
                  color: KardexStyle.grisCampo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  size: 40,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No hay medicamentos registrados',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _abrirFormulario,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Agregar medicamento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KardexStyle.verdeMedico,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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

  Widget _buildMedicamentosList(List<dynamic> medicamentos) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _abrirFormulario,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Agregar medicamento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: KardexStyle.verdeMedico,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: medicamentos.length,
            itemBuilder: (context, index) {
              final med = medicamentos[index];
              return _buildMedicamentoCard(med);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicamentoCard(dynamic med) {
    final horarios = List<String>.from(med['horarios'] ?? []);
    return Dismissible(
      key: Key(med['id'] ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Confirmar eliminación"),
              content: const Text("¿Estás seguro de que deseas eliminar este medicamento?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
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
      onDismissed: (direction) async {
        await _kardexService.eliminarMedicamento(
          pacienteId: widget.pacienteId,
          medicamentoId: med['id'],
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medicamento eliminado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: const Icon(
                    Icons.medication_outlined,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            med['nombre'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Dosis: ',
                              style: const TextStyle(
                                  color: Color(0xFF6B7280), fontSize: 14),
                              children: [
                                TextSpan(
                                  text: med['dosis'] ?? '',
                                  style: const TextStyle(
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Vía: ',
                              style: const TextStyle(
                                  color: Color(0xFF6B7280), fontSize: 14),
                              children: [
                                TextSpan(
                                  text: _shortenVia(med['via'] ?? ''),
                                  style: const TextStyle(
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (horarios.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            horarios.map((h) => _buildHorarioChip(h, med)).toList(),
                      ),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => _abrirFormulario(med),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.edit, size: 20, color: Color(0xFF9CA3AF)),
                        ),
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

  String _shortenVia(String via) {
    if (via.contains('(IV)')) return 'IV';
    if (via.contains('(IM)')) return 'IM';
    if (via.contains('(SC)')) return 'SC';
    if (via.contains('(VO)')) return 'VO';
    if (via.contains('(SL)')) return 'SL';
    if (via.contains('(OFT)')) return 'OFT';
    if (via.contains('(INH)')) return 'INH';
    if (via == 'Ótica') return 'Ótica';
    if (via == 'Tópica') return 'Tópica';
    return via;
  }

  Widget _buildHorarioChip(String time, dynamic med) {
    final administrados = List<String>.from(med['administrados'] ?? []);
    final isAdministrado = administrados.contains(time);

    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;

    final parts = time.split(':');
    bool isOverdue = false;
    if (parts.length == 2) {
      final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      isOverdue = minutes < currentTime;
    }

    Color bgColor;
    Color textColor;
    TextDecoration decoration = TextDecoration.none;

    if (isAdministrado) {
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade500;
      decoration = TextDecoration.lineThrough;
    } else if (isOverdue) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFEF4444);
    } else {
      bgColor = const Color(0xFFEFF6FF);
      textColor = const Color(0xFF2563EB);
    }

    return GestureDetector(
      onTap: () => _toggleAdministrado(med, time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            decoration: decoration,
          ),
        ),
      ),
    );
  }

  Future<void> _toggleAdministrado(dynamic med, String horario) async {
    final Map<String, dynamic> updatedMed = Map<String, dynamic>.from(med);
    final administrados = List<String>.from(updatedMed['administrados'] ?? []);

    if (administrados.contains(horario)) {
      administrados.remove(horario);
    } else {
      administrados.add(horario);
    }

    updatedMed['administrados'] = administrados;

    await _kardexService.actualizarMedicamento(
      pacienteId: widget.pacienteId,
      medicamentoActualizado: updatedMed,
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
              color: Colors.black.withValues(alpha: 0.03),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editandoId != null ? 'Editar Medicamento' : 'Nuevo Medicamento',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const Text(
                        'Asignar dosis y horario',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _mostrarFormulario = false;
                      _editandoId = null;
                    });
                  },
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Fila 1: Nombre del medicamento
            CustomKardexInput(
              controller: _nombreController,
              icon: Icons.medication_outlined,
              label: 'Nombre del medicamento',
              hintText: 'Ej: Ceftriaxona',
            ),
            const SizedBox(height: 16),

            // Fila 2: Dos columnas iguales para "Dosis" y "Vía de administración"
            Row(
              children: [
                Expanded(
                  child: CustomKardexInput(
                    controller: _dosisController,
                    icon: Icons.science_outlined,
                    label: 'Dosis',
                    hintText: 'Ej: 1g',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _viaController.text.isNotEmpty
                        ? _viaController.text
                        : 'Intravenosa (IV)',
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: KardexStyle.verdeMedico),
                    decoration: InputDecoration(
                      labelText: 'Vía de admin...',
                      labelStyle: const TextStyle(
                          color: Color(0xFF6B7280), fontSize: 13),
                      prefixIcon: const Icon(Icons.route_outlined,
                          color: KardexStyle.verdeMedico, size: 20),
                      filled: true,
                      fillColor: KardexStyle.grisCampo,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: KardexStyle.verdeMedico, width: 1.5),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Intravenosa (IV)',
                          child: Text('Intravenosa (IV)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Intramuscular (IM)',
                          child: Text('Intramuscular (IM)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Subcutánea (SC)',
                          child: Text('Subcutánea (SC)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Oral (VO)',
                          child: Text('Oral (VO)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Sublingual (SL)',
                          child: Text('Sublingual (SL)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Oftálmica (OFT)',
                          child: Text('Oftálmica (OFT)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Ótica',
                          child: Text('Ótica',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Inhalatoria (INH)',
                          child: Text('Inhalatoria (INH)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(
                          value: 'Tópica',
                          child: Text('Tópica',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13))),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _viaController.text = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fila 3: Frecuencia/Horario (Full width)
            const Text(
              'Horarios',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            if (_horariosList.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _horariosList.map((timeStr) {
                  return Chip(
                    label: Text(timeStr),
                    backgroundColor: KardexStyle.verdeMedico.withOpacity(0.1),
                    labelStyle: const TextStyle(
                        color: KardexStyle.verdeMedico,
                        fontWeight: FontWeight.bold),
                    deleteIconColor: KardexStyle.verdeMedico,
                    onDeleted: () {
                      setState(() {
                        _horariosList.remove(timeStr);
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(
                        color: KardexStyle.verdeMedico.withOpacity(0.3)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _agregarHorario,
                icon: const Icon(Icons.add, color: Color(0xFF4B5563), size: 18),
                label: const Text(
                  'Agregar horario',
                  style: TextStyle(
                      color: Color(0xFF4B5563), fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: KardexStyle.grisCampo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            // Bottom Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _mostrarFormulario = false;
                        _editandoId = null;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: KardexStyle.grisCampo,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isValid ? _registrarMedicamento : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValid
                          ? KardexStyle.verdeMedico
                          : Colors.grey.shade400,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _editandoId != null ? 'Actualizar Medicamento' : 'Registrar Medicamento',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
