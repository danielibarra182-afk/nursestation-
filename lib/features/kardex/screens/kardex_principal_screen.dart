import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'agregar_paciente_screen.dart';
import 'detalle_px_layout.dart';
import '../../../models/patient_model.dart';

class KardexPrincipalScreen extends StatefulWidget {
  const KardexPrincipalScreen({super.key});

  @override
  State<KardexPrincipalScreen> createState() => _KardexPrincipalScreenState();
}

class _KardexPrincipalScreenState extends State<KardexPrincipalScreen> {
  final Color temaColor = const Color(0xFF0CA79E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Botón flotante solicitado en la instrucción escrita
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarPacienteScreen(),
            ),
          );
        },
        backgroundColor: temaColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box('pacientes').listenable(),
          builder: (context, Box box, _) {
            // Evaluamos si existen pacientes reales en Hive
            final isRealEmpty = box.isEmpty;

            // Datos de prueba (Mocks) que se inyectan solo si no hay pacientes reales, AL INICIO
            // Para mostrarte el diseño como solicitaste, usaremos esta lista en memoria
            // pero manteniendo la regla de que si está completamente vacío muestra la app principal.
            // Para poder ver ambas interfaces, basta con que agregues un paciente nuevo usando el FAB.

            return Column(
              children: [
                // --- Top Header ---
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: temaColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: temaColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.assignment_outlined,
                              color: Colors.white, size: 40),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kardex',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF001F3F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Registro y gestión de pacientes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isRealEmpty) ...[
                  // --- Estado Vacío (Pantalla original) ---
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SingleChildScrollView(
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40.0, horizontal: 24.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person_outline,
                                      size: 45, color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Sin pacientes registrados',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF001F3F)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Comienza registrando el primer\npaciente para gestionar su\ninformación y tratamientos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      height: 1.5),
                                ),
                                const SizedBox(height: 48),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AgregarPacienteScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.add,
                                        color: Colors.white, size: 20),
                                    label: const Text('Registrar paciente',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: temaColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // --- Estado con Lista (Card de Pacientes) ---
                  // Barra de Búsqueda
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar paciente por nombre o expedient',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),

                  // Lista de Pacientes
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      itemCount: box.values.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final PatientModel patient =
                            box.getAt(index) as PatientModel;
                        return _buildPatientCard(context, patient);
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, PatientModel patient) {
    return Dismissible(
      key: Key(patient.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmar Eliminación'),
              content: const Text('¿Estás seguro de eliminar a este paciente?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Eliminar',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        final box = Hive.box('pacientes');
        await box.delete(patient.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Paciente eliminado'),
              action: SnackBarAction(
                label: 'Deshacer',
                textColor: Colors.yellow,
                onPressed: () async {
                  await box.put(patient.id, patient);
                },
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  0.04), // Sombra muy sutil para dar la profundidad deseada
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePxLayout(paciente: patient),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCardContent(patient),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(PatientModel patient) {
    // 1. Vitals & Estado logic
    final Map<dynamic, dynamic>? lastVitals = (patient.signosVitales != null && patient.signosVitales!.isNotEmpty) 
        ? patient.signosVitales!.last as Map<dynamic, dynamic> 
        : null;

    String estado = "Estable";
    Color estadoColor = Colors.green;
    if (lastVitals != null) {
      bool delicado = false;
      final taStr = lastVitals['ta']?.toString() ?? '';
      if (taStr.contains('/')) {
        final parts = taStr.split('/');
        final sys = int.tryParse(parts[0]) ?? 120;
        final dia = int.tryParse(parts[1]) ?? 80;
        if (sys > 130 || sys < 90 || dia > 90 || dia < 60) delicado = true;
      }
      final fc = int.tryParse(lastVitals['fc']?.toString() ?? '') ?? 70;
      if (fc > 100 || fc < 60) delicado = true;
      final temp = double.tryParse(lastVitals['temp']?.toString() ?? '') ?? 36.5;
      if (temp > 37.5 || temp < 36.0) delicado = true;

      if (delicado) {
        estado = "Delicado";
        estadoColor = Colors.orange;
      }
    }

    // 2. Solución logic
    String? solucionText;
    if (patient.solucionesBase != null && patient.solucionesBase!.isNotEmpty) {
      final lastSol = patient.solucionesBase!.last as Map<dynamic, dynamic>;
      solucionText = "${lastSol['nombre'] ?? 'Sol.'} ${lastSol['ml_h'] ?? '-'} mL/h";
    }

    // 3. Meds logic
    String? nextMedText;
    if (patient.medicamentos.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime? closestTime;
      String? medName;
      for (var medDynamic in patient.medicamentos) {
        final med = medDynamic as Map<dynamic, dynamic>;
        final horarios = med['horarios'] as List<dynamic>? ?? [];
        for (var horario in horarios) {
          final timeStr = horario.toString();
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            final hour = int.tryParse(parts[0]) ?? 0;
            final minute = int.tryParse(parts[1]) ?? 0;
            DateTime medDate = DateTime(now.year, now.month, now.day, hour, minute);
            if (medDate.isBefore(now)) medDate = medDate.add(const Duration(days: 1));
            if (closestTime == null || medDate.isBefore(closestTime)) {
              closestTime = medDate;
              medName = med['nombre']?.toString();
            }
          }
        }
      }
      if (closestTime != null && medName != null) {
        final hourStr = closestTime.hour.toString().padLeft(2, '0');
        final minStr = closestTime.minute.toString().padLeft(2, '0');
        nextMedText = "$medName a las $hourStr:$minStr";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: temaColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person_outline, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          patient.nombre,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001F3F)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (solucionText != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 4,
                          child: Text(
                            solucionText,
                            style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Exp: ${patient.id.substring(0, 8)}  •  ${patient.edad} años',
                          style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.diagnostico.isNotEmpty ? patient.diagnostico : 'SD',
                              style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (nextMedText != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.medication, size: 12, color: Colors.purple[400]),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      nextMedText,
                                      style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (lastVitals != null)
                            Text(
                              estado,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: estadoColor),
                            ),
                          const SizedBox(height: 4),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Divider
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(color: Color(0xFFF3F4F6), height: 1),
        ),
        // Signos Vitales Chips
        if (lastVitals != null)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (lastVitals['ta'] != null && lastVitals['ta'].toString().isNotEmpty)
                _buildVitalChip(Icons.monitor_heart, lastVitals['ta'].toString(), const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
              if (lastVitals['fc'] != null && lastVitals['fc'].toString().isNotEmpty)
                _buildVitalChip(Icons.favorite, "${lastVitals['fc']} lpm", const Color(0xFFFCE7F3), const Color(0xFFEC4899)),
              if (lastVitals['fr'] != null && lastVitals['fr'].toString().isNotEmpty)
                _buildVitalChip(Icons.air, "${lastVitals['fr']} rpm", const Color(0xFFE0E7FF), const Color(0xFF4F46E5)),
              if (lastVitals['temp'] != null && lastVitals['temp'].toString().isNotEmpty)
                _buildVitalChip(Icons.thermostat, "${lastVitals['temp']}°C", const Color(0xFFFFEDD5), const Color(0xFFF97316)),
              if (lastVitals['spo2'] != null && lastVitals['spo2'].toString().isNotEmpty)
                _buildVitalChip(Icons.water_drop, "SpO2 ${lastVitals['spo2']}%", const Color(0xFFDBEAFE), const Color(0xFF3B82F6)),
              if (lastVitals['glucosa'] != null && lastVitals['glucosa'].toString().isNotEmpty)
                _buildVitalChip(Icons.bloodtype, "${lastVitals['glucosa']} mg/dL", const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
            ],
          )
        else
          const Text("Sin signos vitales registrados", style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVitalChip(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
