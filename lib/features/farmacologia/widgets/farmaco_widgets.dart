import 'package:flutter/material.dart';
import '../../../models/farmaco_model.dart';

// ─── COMPONENTES PARA LISTA DE FÁRMACOS ────────────────────────

class FarmacoTile extends StatelessWidget {
  final Farmaco med;
  final VoidCallback onTap;

  const FarmacoTile({
    super.key,
    required this.med,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getCategoryColor(med.categoria);
    final bgColor = primaryColor.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: 'icon_${med.nombre}',
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medication_outlined,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        med.grupo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: [
                          ...med.vias.map((ruta) => RouteChip(text: ruta)),
                          CategoryChip(text: med.categoria),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Analgésicos': return const Color(0xFFE65100);
      case 'Antibióticos': return const Color(0xFF00695C);
      case 'Cardiovascular': return const Color(0xFF1565C0);
      case 'Digestivos': return const Color(0xFF7B1FA2);
      case 'Anticoagulantes': return const Color(0xFFC62828);
      case 'Esteroides': return const Color(0xFF283593);
      case 'Soluciones': return const Color(0xFF00838F);
      case 'Electrolitos': return const Color(0xFFF9A825);
      default: return const Color(0xFF10B981);
    }
  }
}

class RouteChip extends StatelessWidget {
  final String text;
  const RouteChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1565C0),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  const CategoryChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

// ─── COMPONENTES PARA DETALLE DE FÁRMACO ───────────────────────

class FarmacoAccordion extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget content;

  const FarmacoAccordion({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: color, size: 26),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color(0xFF1F2937),
            ),
          ),
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}

class DoseBox extends StatelessWidget {
  final String title;
  final String text;

  const DoseBox({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text.isEmpty ? 'Información no disponible' : text,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class InfusionBox extends StatelessWidget {
  final String title;
  final String content;

  const InfusionBox({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    // Si el contenido ya incluye la palabra "minutos", no añadimos el sufijo
    final bool showSuffix = !content.toLowerCase().contains('minuto');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.access_time_rounded, color: Color(0xFF1E40AF), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(text: content),
                      if (showSuffix)
                        const TextSpan(
                          text: ' minutos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PregnancyCategoryChip extends StatelessWidget {
  final String category;

  const PregnancyCategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    if (category.isEmpty) return const Text('Información no disponible', style: TextStyle(color: Colors.grey));

    Color chipColor = const Color(0xFFFEF3C7);
    Color textColor = const Color(0xFF92400E);
    
    if (category.contains('A') || category.contains('B')) {
      chipColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
    } else if (category.contains('D') || category.contains('X')) {
      chipColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.child_friendly_rounded, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            'Categoría $category (FDA)',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const StatusRow({super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }
}

class GenericChip extends StatelessWidget {
  final String label;
  final Color color;

  const GenericChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
