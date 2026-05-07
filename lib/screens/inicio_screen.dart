import 'package:flutter/material.dart';
import '../widgets/quick_acces_card.dart';
import '../widgets/top_icon.dart';
import 'goteo_flujo/calculadora_maestra_screen.dart';
import '../features/kardex/screens/agregar_paciente_screen.dart';
import '../features/kardex/screens/kardex_principal_screen.dart';
import '../features/farmacologia/screens/farmaco_menu_screen.dart';
import '../widgets/master_layout.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _selectedIndex = 0;

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
                    onTap: () => setState(() => _selectedIndex = 3),
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
        content = const FarmacoMenuScreen();
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
                    onTap: () => setState(() => _selectedIndex = 3),
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
