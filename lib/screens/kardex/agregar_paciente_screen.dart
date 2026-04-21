import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/patient_model.dart';

class AgregarPacienteScreen extends StatefulWidget {
  const AgregarPacienteScreen({super.key});

  @override
  State<AgregarPacienteScreen> createState() => _AgregarPacienteScreenState();
}

class _AgregarPacienteScreenState extends State<AgregarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nombreController = TextEditingController();
  final _diagnosticoController = TextEditingController();
  
  DateTime? _fechaNacimiento;
  int _edadCalculada = 0;

  @override
  void dispose() {
    _nombreController.dispose();
    _diagnosticoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)), // 30 años aprox
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981), // Cabecera verde esmeralda
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
        _calcularEdad(picked);
      });
    }
  }

  void _calcularEdad(DateTime fechaNacimiento) {
    final DateTime hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month || 
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    _edadCalculada = edad;
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
  }

  void _guardarPaciente() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaNacimiento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona la fecha de nacimiento')),
        );
        return;
      }

      final nuevoPaciente = PatientModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text.trim(),
        cama: 'No Asignada', // Default mock para cumplir con el modelo
        edad: _edadCalculada,
        diagnostico: _diagnosticoController.text.trim(),
        medicamentos: [], // Default mock
        notas: '', // Default mock
      );

      final box = Hive.box('pacientes');
      await box.put(nuevoPaciente.id, nuevoPaciente);

      if (mounted) {
        Navigator.pop(context); // Cierra el modal/pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paciente registrado. Edad calculada: $_edadCalculada años.'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color esmeralda = Color(0xFF10B981); // Acorde a sus especificaciones
    const Color tealBoton = Color(0xFF00B4A2); // El teal del boton de la imagen

    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Top Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registrar paciente',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF001F3F), // Texto oscuro
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.blueGrey, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // --- Campo: Nombre Completo ---
                _buildFieldLabel('Nombre completo'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nombreController,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  decoration: _inputDecoration(
                    hint: 'Ej: Juan Pérez García',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Campo: Fecha de Nacimiento ---
                _buildFieldLabel('Fecha de nacimiento'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer( // Absorbe toques para no abrir teclado
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: _fechaNacimiento != null 
                            ? _formatearFecha(_fechaNacimiento!) 
                            : 'dd/mm/aaaa',
                        hintStyle: TextStyle(
                          color: _fechaNacimiento != null ? Colors.black87 : Colors.grey[500], 
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[500], size: 22),
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.black87, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Campo: Diagnóstico Médico ---
                _buildFieldLabel('Diagnóstico'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _diagnosticoController,
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  decoration: InputDecoration(
                    hintText: 'Ej: Neumonía adquirida en la comunidad',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0), // Alinear icono arriba
                      child: Icon(Icons.medical_services_outlined, color: Colors.grey[500], size: 22),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 48),

                // --- Botones Botón Inferiores ---
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: const Color(0xFF001F3F),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _guardarPaciente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tealBoton, // Esmeralda
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Registrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF4B5563), // Gris neutro
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100], // Fondo gris claro sin línea
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
