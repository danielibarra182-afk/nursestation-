import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';
import '../tabs/solucion_base_tab.dart';
import '../tabs/infusiones_tab.dart';
import '../tabs/medicamentos_tab.dart';
import '../tabs/signos_vitales_tab.dart';

class DetallePxLayout extends StatelessWidget {
  final PatientModel paciente;

  const DetallePxLayout({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    const Color temaColor = Color(0xFF0CA79E);
    const Color tabSeleccionadoColor = Color(0xFF00C7D1);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), // Fondo claro
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botón Volver
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back,
                        color: temaColor, size: 20),
                    label: const Text(
                      'Volver',
                      style: TextStyle(
                        color: temaColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),

              // Tarjeta de Paciente
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('pacientes').listenable(),
                  builder: (context, box, child) {
                    final p = box.get(paciente.id) as PatientModel? ?? paciente;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C7D1), Color(0xFF0CA79E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: temaColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Fondo decorativo (círculos)
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -30,
                            bottom: -30,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                          ),

                          // Contenido de la tarjeta
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.nombre,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Cama: ${p.cama}',
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.2),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                color: Colors.white,
                                                size: 20),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _EditarPacienteDialog(
                                                        paciente: p),
                                              );
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(8),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.2),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.person_outline,
                                                color: Colors.white,
                                                size: 24),
                                            onPressed: () {},
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Edad',
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${p.edad} años',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID Paciente',
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            p.id.length > 5
                                                ? p.id
                                                    .substring(p.id.length - 5)
                                                : p.id,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Diagnóstico',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.diagnostico,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Custom TabBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[100]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: tabSeleccionadoColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF4B5563),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Tab(text: 'Solución'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Tab(text: 'Infusiones'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Tab(text: 'Medicamentos'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Tab(text: 'S. Vitales'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    SolucionBaseTab(pacienteId: paciente.id),
                    InfusionesTab(pacienteId: paciente.id),
                    MedicamentosTab(pacienteId: paciente.id),
                    SignosVitalesTab(pacienteId: paciente.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditarPacienteDialog extends StatefulWidget {
  final PatientModel paciente;

  const _EditarPacienteDialog({required this.paciente});

  @override
  State<_EditarPacienteDialog> createState() => _EditarPacienteDialogState();
}

class _EditarPacienteDialogState extends State<_EditarPacienteDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _camaController;
  late TextEditingController _edadController;
  late TextEditingController _diagnosticoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.paciente.nombre);
    _camaController = TextEditingController(text: widget.paciente.cama);
    _edadController =
        TextEditingController(text: widget.paciente.edad.toString());
    _diagnosticoController =
        TextEditingController(text: widget.paciente.diagnostico);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _camaController.dispose();
    _edadController.dispose();
    _diagnosticoController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_nombreController.text.trim().isEmpty) return;

    widget.paciente.nombre = _nombreController.text.trim();
    widget.paciente.cama = _camaController.text.trim();
    widget.paciente.edad =
        int.tryParse(_edadController.text.trim()) ?? widget.paciente.edad;
    widget.paciente.diagnostico = _diagnosticoController.text.trim();

    if (widget.paciente.isInBox) {
      widget.paciente.save();
    } else {
      Hive.box('pacientes').put(widget.paciente.id, widget.paciente);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Identificación',
          style: TextStyle(fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _edadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Edad',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _camaController,
                    decoration: InputDecoration(
                      labelText: 'Cama',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosticoController,
              decoration: InputDecoration(
                labelText: 'Diagnóstico',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0CA79E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Guardar Cambios',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
