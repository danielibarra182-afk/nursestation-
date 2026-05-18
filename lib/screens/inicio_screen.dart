import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/quick_acces_card.dart';
import '../widgets/top_icon.dart';
import 'goteo_flujo/calculadora_maestra_screen.dart';
import '../features/kardex/screens/agregar_paciente_screen.dart';
import '../features/kardex/screens/kardex_principal_screen.dart';
import '../features/farmacologia/screens/farmaco_list_screen.dart';
import '../widgets/master_layout.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _selectedIndex = 0;

  Future<void> _attemptNavigateToMedicamentos() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAccepted =
        prefs.getInt('last_accepted_medicamentos_disclaimer') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final int twentyFourHours = 24 * 60 * 60 * 1000;

    if (now - lastAccepted < twentyFourHours) {
      setState(() => _selectedIndex = 3);
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF59D), // Recuadro amarillo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.orange, width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AVISO LEGAL Y DESLINDE DE RESPONSABILIDAD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              '1. Carácter Exclusivamente Informativo y de Apoyo\n'
              'Este compendio farmacológico es una guía de consulta rápida diseñada única y exclusivamente como material de apoyo técnico para profesionales de la salud. La información contenida en esta aplicación —incluyendo dosis, posología, diluciones, compatibilidades y tiempos de infusión— tiene un fin estrictamente educativo e informativo. Esta aplicación no está dirigida al público en general ni a personas ajenas al sector salud.\n\n'
              '2. Obligación de Seguir Protocolos Institucionales y Margen de Error Técnico\n'
              'El usuario acepta que esta aplicación es una herramienta complementaria y que no sustituye, bajo ninguna circunstancia, los manuales de procedimientos, vademécums oficiales, guías de práctica clínica ni los protocolos específicos de la institución u hospital donde labora. Debido a la naturaleza digital de la plataforma, el contenido no está exento de presentar involuntariamente errores tipográficos, de transcripción o de captura de datos. Por lo tanto, es obligación y responsabilidad estricta del profesional verificar la vigencia y exactitud de los datos con las fuentes oficiales de su unidad médica antes de administrar cualquier fármaco.\n\n'
              '3. Individualización del Paciente\n'
              'La medicina y la enfermería no son ciencias exactas; la información aquí presentada no debe considerarse infalible o absoluta. Cada paciente es diferente y los esquemas terapéuticos deben individualizarse según el estado clínico, función renal, hepática, edad, peso y comorbilidades del paciente.\n\n'
              '4. Deslinde de Responsabilidad Humana y Técnica\n'
              'Ni la aplicación, ni su equipo de desarrollo o colaboradores, asumen responsabilidad alguna por:\n'
              '• Errores, omisiones o imprecisiones en los datos de dosificación o preparación.\n'
              '• Daños, perjuicios o eventos adversos derivados de la interpretación o mala aplicación de la información.\n'
              '• Fallas técnicas en los cálculos o visualización del contenido.\n\n'
              '5. Responsabilidad Profesional y Barreras de Seguridad (Los 10 Correctos)\n'
              'Cada profesional de la salud es única, total y legalmente responsable del manejo y seguridad de sus pacientes. El acto de prescribir, transcribir, preparar y administrar medicamentos es una facultad que recae exclusivamente en el criterio clínico y la cédula profesional del usuario. Es responsabilidad estricta e intransferible del operador aplicar y verificar de manera estricta los 10 correctos en la administración de medicamentos (paciente correcto, medicamento correcto, dosis correcta, vía correcta, hora correcta, verificar fecha de caducidad, preparar y administrar uno mismo, registrar uno mismo, velocidad de infusión correcta y conocer las alteraciones secundarias). El uso de esta aplicación implica la total aceptación de estos términos y exime a los desarrolladores de cualquier responsabilidad legal o clínica derivada del proceso de medicación.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Denegar',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('last_accepted_medicamentos_disclaimer',
                    DateTime.now().millisecondsSinceEpoch);
                if (mounted) {
                  Navigator.of(context).pop();
                  setState(() => _selectedIndex = 3);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceptar',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInicioContent() {
    return MasterLayout(
      title: 'Goteo IV Pro',
      subtitle: 'Cálculo rápido y preciso para personal de salud',
      icon: Icons.water_drop,
      primaryColor: const Color(0xFF1B5AE6),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección Acceso Rápido
              const Text(
                'Acceso Rápido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 20),
              // Lista de accesos rápidos
              Column(
                children: [
                  QuickAccessCard(
                    title: 'Goteo IV',
                    subtitle: 'Cálculo de macrogoteo y microgoteo',
                    icon: Icons.water_drop,
                    iconColor: const Color(0xFF1B5AE6),
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  QuickAccessCard(
                    title: 'Kardex de Pacientes',
                    subtitle: 'Gestión de pacientes',
                    icon: Icons.assignment_ind,
                    iconColor: const Color(0xFF40E0D0),
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  QuickAccessCard(
                    title: 'Medicamentos',
                    subtitle: 'compendio de medicamentos',
                    icon: Icons.medication,
                    iconColor: const Color(0xFFF59E0B),
                    onTap: _attemptNavigateToMedicamentos,
                  ),
                  const QuickAccessCard(
                    title: 'Ajustes',
                    subtitle: 'Configuración general',
                    icon: Icons.settings,
                    iconColor: Color(0xFF6B7280),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return MasterLayout(
      title: title,
      subtitle: 'En construcción',
      icon: Icons.build,
      primaryColor: const Color(0xFF6B7280),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = _buildInicioContent();
        break;
      case 1:
        content = const CalculadoraMaestraScreen();
        break;
      case 2:
        content = const KardexPrincipalScreen();
        break;
      case 3:
        content = const FarmacoListScreen();
        break;
      case 4:
        content = _buildPlaceholder('Cuenta');
        break;
      default:
        content = _buildInicioContent();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de navegación superior
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E7EB), // Línea inferior sutil
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  TopIcon(
                    text: 'Inicio',
                    icon: Icons.home_outlined,
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  TopIcon(
                    text: 'Goteo/Flujo',
                    icon: Icons.calculate_outlined,
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  TopIcon(
                    text: 'Kardex',
                    icon: Icons.assignment_outlined,
                    isSelected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  TopIcon(
                    text: 'Medicamentos',
                    icon: Icons.medication_outlined,
                    isSelected: _selectedIndex == 3,
                    onTap: () {
                      if (_selectedIndex != 3) {
                        _attemptNavigateToMedicamentos();
                      }
                    },
                  ),
                  TopIcon(
                    text: 'Cuenta',
                    icon: Icons.person_outline,
                    isSelected: _selectedIndex == 4,
                    onTap: () => setState(() => _selectedIndex = 4),
                  ),
                ],
              ),
            ),
            // Contenido de la pantalla actual debajo de la barra
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
