import 'package:flutter/material.dart';

class TopIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const TopIcon({
    Key? key,
    required this.text,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definimos colores dinámicos basados en el estado de selección
    final Color contentColor = isSelected 
        ? const Color(0xFF1B5AE6) // Color azul principal (cuando está seleccionado)
        : const Color(0xFF6B7280); // Color gris suave (no seleccionado)

    // Solo dibujamos la línea indicadora inferior cuando está seleccionado
    final Border border = isSelected 
        ? const Border(bottom: BorderSide(color: Color(0xFF1B5AE6), width: 3.0))
        : const Border(bottom: BorderSide(color: Colors.transparent, width: 3.0));

    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap ?? () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              border: border,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: contentColor,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
