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
              child: Row(
                children: [
                  // Cabecera: Círculo esmeralda / Squircle (como la imagen)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: temaColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Detalles del paciente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001F3F),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Exp: ${patient.id.substring(0, 8)}  •  ${patient.edad} años',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          patient.diagnostico.isNotEmpty
                              ? patient.diagnostico
                              : 'SD',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Flecha de navegación a la derecha
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
