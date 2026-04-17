import 'package:flutter/material.dart';
import '../widgets/quick_acces_card.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Ícono grande centrado
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B5AE6), // Azul de la referencia
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x4D1B5AE6), // Color con opacidad 0.3 sin llamar un método en contexto const
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Título
                const Text(
                  'Goteo IV Pro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtítulo descriptivo
                const Text(
                  'Cálculo rápido y preciso para personal de salud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 48),
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
                // Lista de accesos rápidos ajustada al nuevo formato de tarjeta tipo fila
                const Column(
                  children: [
                    QuickAccessCard(
                      title: 'Goteo IV',
                      subtitle: 'Cálculo de macrogoteo y microgoteo',
                      icon: Icons.water_drop,
                      iconColor: Color(0xFF1B5AE6),
                    ),
                    QuickAccessCard(
                      title: 'Kardex Médico',
                      subtitle: 'Gestión de pacientes',
                      icon: Icons.folder_shared,
                      iconColor: Color(0xFF10B981),
                    ),
                    QuickAccessCard(
                      title: 'Historial',
                      subtitle: 'Cálculos anteriores',
                      icon: Icons.history,
                      iconColor: Color(0xFFF59E0B),
                    ),
                    QuickAccessCard(
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
      ),
    );
  }
}
