import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/patient_model.dart';
import '../tabs/solucion_base_tab.dart';
import '../tabs/infusiones_tab.dart';
import '../tabs/medicamentos_tab.dart';
import '../tabs/signos_vitales_tab.dart';
import '../../../widgets/master_layout.dart';

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
        backgroundColor: const Color(0xFFF9FAFB),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 380.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: temaColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final top = constraints.biggest.height;
                    final statusBarHeight = MediaQuery.of(context).padding.top;
                    final pinnedHeight =
                        kToolbarHeight + 80.0 + statusBarHeight;

                    double opacityExpanded = (top - pinnedHeight) / 50.0;
                    opacityExpanded = opacityExpanded.clamp(0.0, 1.0);

                    double opacityCollapsed = 1.0 - opacityExpanded;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background
                        Container(color: temaColor),

                        // Expanded Content (Patient Card)
                        if (opacityExpanded > 0)
                          Positioned(
                            top: statusBarHeight + kToolbarHeight,
                            left: 0,
                            right: 0,
                            bottom: 80.0, // space for TabBar
                            child: AnimatedOpacity(
                              duration: Duration.zero,
                              opacity: opacityExpanded,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: _buildExpandedCard(
                                    context, paciente, temaColor),
                              ),
                            ),
                          ),

                        // Collapsed Title
                        if (opacityCollapsed > 0)
                          Positioned(
                            left: 72,
                            right: 16,
                            top: statusBarHeight + (kToolbarHeight - 24) / 2,
                            child: AnimatedOpacity(
                              duration: Duration.zero,
                              opacity: opacityCollapsed,
                              child: Text(
                                paciente.nombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 15.0),
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
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SolucionBaseTab(pacienteId: paciente.id),
              InfusionesTab(pacienteId: paciente.id),
              MedicamentosTab(pacienteId: paciente.id),
              SignosVitalesTab(pacienteId: paciente.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard(
      BuildContext context, PatientModel paciente, Color temaColor) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('pacientes').listenable(),
      builder: (context, box, child) {
        final p = box.get(paciente.id) as PatientModel? ?? paciente;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Container(
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
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cama: ${p.cama}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
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
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: Colors.white, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          _EditarPacienteDialog(paciente: p),
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
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.person_outline,
                                      color: Colors.white, size: 24),
                                  onPressed: () {},
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edad',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 2),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID Paciente',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.id.length > 5
                                      ? p.id.substring(p.id.length - 5)
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
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'F. Nacimiento',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.fechaNacimiento ?? 'SD',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alergias',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.alergias ?? 'Ninguna',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Diagnóstico',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.diagnostico,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
  late TextEditingController _idController;
  late TextEditingController _camaController;
  late TextEditingController _edadController;
  late TextEditingController _diagnosticoController;
  late TextEditingController _alergiasController;
  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.paciente.nombre);
    _idController = TextEditingController(text: widget.paciente.id);
    _camaController = TextEditingController(text: widget.paciente.cama);
    _edadController =
        TextEditingController(text: widget.paciente.edad.toString());
    _diagnosticoController =
        TextEditingController(text: widget.paciente.diagnostico);
    _alergiasController = TextEditingController(
        text: widget.paciente.alergias == 'Ninguna'
            ? ''
            : widget.paciente.alergias);

    _fechaNacimiento = _parseFecha(widget.paciente.fechaNacimiento);
  }

  DateTime? _parseFecha(String? fechaStr) {
    if (fechaStr == null || fechaStr == 'SD') return null;
    try {
      final parts = fechaStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ??
          DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
        // Recalcular edad
        final hoy = DateTime.now();
        int edad = hoy.year - picked.year;
        if (hoy.month < picked.month ||
            (hoy.month == picked.month && hoy.day < picked.day)) {
          edad--;
        }
        _edadController.text = edad.toString();
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _idController.dispose();
    _camaController.dispose();
    _edadController.dispose();
    _diagnosticoController.dispose();
    _alergiasController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_nombreController.text.trim().isEmpty) return;

    final String oldId = widget.paciente.id;
    final String newId = _idController.text.trim();

    widget.paciente.nombre = _nombreController.text.trim();
    widget.paciente.cama = _camaController.text.trim();
    widget.paciente.edad =
        int.tryParse(_edadController.text.trim()) ?? widget.paciente.edad;
    widget.paciente.diagnostico = _diagnosticoController.text.trim();
    widget.paciente.alergias = _alergiasController.text.trim().isNotEmpty
        ? _alergiasController.text.trim()
        : 'Ninguna';

    if (_fechaNacimiento != null) {
      widget.paciente.fechaNacimiento = _formatearFecha(_fechaNacimiento!);
    }

    if (newId.isNotEmpty && oldId != newId) {
      widget.paciente.id = newId;
      Hive.box('pacientes').delete(oldId);
      Hive.box('pacientes').put(newId, widget.paciente);
    } else {
      if (widget.paciente.isInBox) {
        widget.paciente.save();
      } else {
        Hive.box('pacientes').put(widget.paciente.id, widget.paciente);
      }
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
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID Paciente',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            // Fecha de Nacimiento
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
                child: Text(
                  _fechaNacimiento != null
                      ? _formatearFecha(_fechaNacimiento!)
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: _fechaNacimiento != null
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
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
            const SizedBox(height: 16),
            TextField(
              controller: _alergiasController,
              decoration: InputDecoration(
                labelText: 'Alergias',
                hintText: 'Penicilina, Ninguna...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 1,
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
