import 'package:flutter/material.dart';
import '../widgets/custom_kardex_input.dart';
import '../../../services/kardex/kardex_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';
import '../widgets/kardex_style.dart';

class InfusionesTab extends StatefulWidget {
  final String pacienteId;

  const InfusionesTab({super.key, required this.pacienteId});

  @override
  State<InfusionesTab> createState() => _InfusionesTabState();
}

class _InfusionesTabState extends State<InfusionesTab> {
  bool _mostrarFormulario = true;
  String? _editandoId;
  String? _fechaOriginal;
  String _categoriaSeleccionada = 'Medicamento';

  final _medicamentoController = TextEditingController();
  final _volumenController = TextEditingController();
  final _velocidadController = TextEditingController();

  final List<String> _categorias = [
    'Medicamento',
    'Nutrición',
    'Hemocomponente',
    'Otro'
  ];

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
        paciente = box.values.firstWhere(
                (p) => p is PatientModel && p.id == widget.pacienteId)
            as PatientModel?;
      } catch (e) {}
    }

    final infusiones = paciente?.infusiones ?? [];
    if (infusiones.isNotEmpty) {
      _mostrarFormulario = false;
    }
  }

  @override
  void dispose() {
    _medicamentoController.dispose();
    _volumenController.dispose();
    _velocidadController.dispose();
    _velocidadController.dispose();
    super.dispose();
  }

  void _abrirFormulario([dynamic infusion, int? index]) {
    setState(() {
      _mostrarFormulario = true;
      if (infusion != null) {
        _editandoId = infusion['id'] ?? 'legacy_$index';
        _fechaOriginal = infusion['fecha'];
        _medicamentoController.text = infusion['nombre']?.toString() ?? '';
        _volumenController.text = infusion['volumen']?.toString() ?? '';
        _velocidadController.text = infusion['velocidad']?.toString() ?? '';
        _categoriaSeleccionada = infusion['categoria']?.toString() ?? 'Medicamento';
      } else {
        _editandoId = null;
        _fechaOriginal = null;
        _medicamentoController.clear();
        _volumenController.clear();
        _velocidadController.clear();
        _categoriaSeleccionada = 'Medicamento';
      }
    });
  }

  Future<void> _guardar() async {
    final nombre = _medicamentoController.text.trim();
    final volumenText = _volumenController.text.trim();
    final velocidadText = _velocidadController.text.trim();

    if (nombre.isEmpty || volumenText.isEmpty || velocidadText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    final datos = {
      'id': _editandoId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'nombre': nombre,
      'volumen': double.tryParse(volumenText) ?? 0.0,
      'velocidad': velocidadText,
      'categoria': _categoriaSeleccionada,
      'fecha': _fechaOriginal ?? DateTime.now().toIso8601String(),
    };

    if (_editandoId == null) {
      await KardexService().guardarInfusion(
        pacienteId: widget.pacienteId,
        datos: datos,
      );
    } else {
      await KardexService().actualizarInfusion(
        pacienteId: widget.pacienteId,
        infusionActualizada: datos,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Infusión guardada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _medicamentoController.clear();
      _volumenController.clear();
      _volumenController.clear();
      _velocidadController.clear();
      _editandoId = null;
      _fechaOriginal = null;
      setState(() {
        _categoriaSeleccionada = 'Medicamento';
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
            paciente = box.values.firstWhere(
                    (p) => p is PatientModel && p.id == widget.pacienteId)
                as PatientModel?;
          } catch (e) {}
        }

        final infusiones = paciente?.infusiones ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (infusiones.isNotEmpty) ...[
                const Text(
                  'Infusiones registradas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                _buildListaInfusiones(infusiones),
                const SizedBox(height: 16),
              ],
              if (_mostrarFormulario)
                _buildFormulario()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _abrirFormulario(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2563EB), // Color azul primario
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
                          'AGREGAR NUEVA INFUSIÓN',
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
                child: const Icon(Icons.vaccines,
                    color: Color(0xFF3B82F6), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _editandoId == null ? 'Nueva Infusión' : 'Editar Infusión',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      'Registro de medicamentos y otros fluidos',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              if (Hive.box('pacientes').get(widget.pacienteId) != null &&
                  ((Hive.box('pacientes').get(widget.pacienteId)
                              as PatientModel)
                          .infusiones
                          ?.isNotEmpty ??
                      false))
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _mostrarFormulario = false;
                      _editandoId = null;
                      _fechaOriginal = null;
                    });
                  },
                )
            ],
          ),
          const SizedBox(height: 24),

          // Categoría Selector
          const Text(
            'Categoría',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _categorias.map((String cat) {
              final isSelected = _categoriaSeleccionada == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xFFEFF6FF),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF4B5563),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : Colors.grey[300]!,
                  ),
                ),
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _categoriaSeleccionada = cat;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Nombre del medicamento
          CustomKardexInput(
            icon: Icons.medication,
            label: 'Nombre de la infusión',
            hintText: 'Ej: Dopamina, Paquete Globular',
            controller: _medicamentoController,
          ),
          const SizedBox(height: 16),

          // Volumen and Velocidad Row
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
                      hintText: 'Ej: 500',
                      controller: _volumenController,
                      keyboardType: TextInputType.number,
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
                      icon: Icons.speed,
                      label: 'Velocidad',
                      hintText: 'Ej: 20 mL/h',
                      controller: _velocidadController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Botón Guardar
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
              child: Text(
                _editandoId == null ? 'Guardar Infusión' : 'Actualizar Infusión',
                style: const TextStyle(
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

  Widget _buildListaInfusiones(List<dynamic> infusiones) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: infusiones.length,
      itemBuilder: (context, index) {
        final infIndex = infusiones.length - 1 - index;
        final inf = infusiones[infIndex] as Map<dynamic, dynamic>;

        String fechaMostrada = '';
        if (inf['fecha'] != null) {
          try {
            final dt = DateTime.parse(inf['fecha']);
            fechaMostrada =
                '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
          } catch (e) {
            fechaMostrada = inf['fecha'];
          }
        }

        final categoria = inf['categoria']?.toString() ?? 'Medicamento';
        IconData catIcon = Icons.science;
        if (categoria == 'Hemocomponente') catIcon = Icons.bloodtype;
        if (categoria == 'Nutrición') catIcon = Icons.local_dining;
        if (categoria == 'Otro') catIcon = Icons.vaccines;

        return Dismissible(
          key: Key(inf['id']?.toString() ?? UniqueKey().toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                  content: const Text("¿Estás seguro de eliminar esta infusión?"),
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
            if (inf['id'] != null) {
              KardexService().eliminarInfusion(
                pacienteId: widget.pacienteId,
                infusionId: inf['id'],
              );
            } else {
              var box = Hive.box('pacientes');
              PatientModel? paciente = box.get(widget.pacienteId) as PatientModel?;
              if (paciente == null) {
                try {
                  paciente = box.values.firstWhere((p) => p is PatientModel && p.id == widget.pacienteId) as PatientModel?;
                } catch (e) {}
              }
              if (paciente != null) {
                final lista = List<dynamic>.from(paciente.infusiones ?? []);
                lista.removeAt(infIndex);
                paciente.infusiones = lista;
                if (paciente.isInBox) {
                  paciente.save();
                } else if (paciente.key != null) {
                  box.put(paciente.key, paciente);
                }
              }
            }
          },
          child: Container(
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
                    child:
                        Icon(catIcon, color: const Color(0xFF3B82F6), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inf['nombre']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          categoria,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fechaMostrada,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF9CA3AF), size: 20),
                        onPressed: () => _abrirFormulario(inf, infIndex),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Panel Destacado de Detalles
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: KardexStyle.grisCampo, // Gris claro definido
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Velocidad Programada',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            inf['velocidad']?.toString() ?? '-',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(
                                  0xFF0CA79E), // KardexStyle.turquesa o turquesa principal
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
                            'Volumen Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${inf['volumen']} mL',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
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
        ));
      },
    );
  }
}
