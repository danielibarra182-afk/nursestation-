import 'package:flutter/material.dart';
import 'goteo_iv_view.dart';
import 'flujo_iv_view.dart';
import 'goteo_real_view.dart';

class CalculadoraMaestraScreen extends StatefulWidget {
  const CalculadoraMaestraScreen({super.key});

  @override
  State<CalculadoraMaestraScreen> createState() => _CalculadoraMaestraScreenState();
}

class _CalculadoraMaestraScreenState extends State<CalculadoraMaestraScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      // Reconstruir para actualizar el título y el icono superior
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _currentTitle {
    switch (_tabController.index) {
      case 1:
        return 'Flujo';
      case 2:
        return 'Goteo Real';
      case 0:
      default:
        return 'Goteo IV';
    }
  }

  IconData get _currentIcon {
    switch (_tabController.index) {
      case 1:
        return Icons.speed;
      case 2:
        return Icons.timer;
      case 0:
      default:
        return Icons.water_drop;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el color principal usado en el diseño
    const primaryBlue = Color(0xFF0056D2);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Fondo azul/gris muy claro
      body: Column(
        children: [
          const SizedBox(height: 40), // Espaciado superior
          
          // --- Sección del Header (Icono circular y textos) ---
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _currentIcon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cálculo rápido y preciso para personal de salud',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),

          // --- TabBar central tipo "Segmented Control" ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent, // Quita la linea base
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: primaryBlue,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade700,
                // Ajustamos padding para evitar overflow en pantallas pequeñas
                labelPadding: EdgeInsets.zero,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.water_drop, size: 16),
                        SizedBox(width: 4),
                        Text('Goteo IV', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.speed, size: 16),
                        SizedBox(width: 4),
                        Text('Flujo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, size: 16),
                        SizedBox(width: 4),
                        Text('Goteo Real', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Vistas de cada pestaña ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                GoteoIVView(),
                FlujoIVView(),
                GoteoRealView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
