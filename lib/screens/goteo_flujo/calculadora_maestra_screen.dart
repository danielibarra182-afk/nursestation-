import 'package:flutter/material.dart';
import 'goteo_iv_view.dart';
import 'flujo_iv_view.dart';
import 'goteo_real_view.dart';
import '../../widgets/master_layout.dart';

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

  String get _currentSubtitle {
    switch (_tabController.index) {
      case 1:
        return 'Cálculo de flujo infundido en bombas';
      case 2:
        return 'Mide el goteo real del equipo';
      case 0:
      default:
        return 'Cálculo rápido y preciso para personal de salud';
    }
  }

  IconData get _currentIcon {
    switch (_tabController.index) {
      case 1:
        return Icons.speed;
      case 2:
        return Icons.colorize; // Jeringa/gotero for Goteo Real
      case 0:
      default:
        return Icons.water_drop;
    }
  }

  Color get _currentActiveColor {
    switch (_tabController.index) {
      case 2:
        return const Color(0xFF009688); // Teal (Turquesa oscuro)
      case 0:
      case 1:
      default:
        return const Color(0xFF0056D2); // Primary Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el color principal usado en el diseño
    const primaryBlue = Color(0xFF0056D2);

    return MasterLayout(
      title: _currentTitle,
      subtitle: _currentSubtitle,
      icon: _currentIcon,
      primaryColor: _currentActiveColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent, // Quita la linea base
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _currentActiveColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade700,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
                _buildTab(0, 'Goteo IV', Icons.water_drop_outlined, Icons.water_drop),
                _buildTab(1, 'Flujo', Icons.timer_outlined, Icons.timer),
                _buildTab(2, 'Goteo Real', Icons.colorize, Icons.colorize),
              ],
            ),
          ),
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: const [
          GoteoIVView(),
          FlujoIVView(),
          GoteoRealView(),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String text, IconData unselectedIcon, IconData selectedIcon) {
    bool isSelected = _tabController.index == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? selectedIcon : unselectedIcon, size: index == 2 ? 20 : 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
