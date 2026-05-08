import 'package:flutter/material.dart';

class FarmacoDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> farmaco;

  const FarmacoDetalleScreen({super.key, required this.farmaco});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF10B981); // Color verde médico de la app

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      body: Column(
        children: [
          // Header dinámico
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF075E54).withOpacity(0.9),
                  primaryColor,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Volver',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  farmaco['nombre'] ?? 'Fármaco',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  farmaco['subtitulo'] ?? 'Categoría',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: (farmaco['rutas'] as List<dynamic>? ?? ['IV', 'IM', 'VO']).map((ruta) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ruta.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Lista de Secciones Dinámicas
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildAccordionCard(
                  title: 'Dosis',
                  icon: Icons.balance_rounded,
                  color: primaryColor,
                  content: _buildDosisContent(),
                ),
                _buildAccordionCard(
                  title: 'Compatibilidad IV',
                  icon: Icons.swap_vert_rounded,
                  color: primaryColor,
                  content: _buildCompatibilidadContent(),
                ),
                _buildAccordionCard(
                  title: 'Preparación / Dilución',
                  icon: Icons.science_outlined,
                  color: primaryColor,
                  content: _buildPreparacionContent(),
                ),
                _buildAccordionCard(
                  title: 'Tiempo de infusión',
                  icon: Icons.access_time_rounded,
                  color: primaryColor,
                  content: _buildInfusionContent(),
                ),
                _buildAccordionCard(
                  title: 'Riesgo en el embarazo',
                  icon: Icons.child_friendly_rounded,
                  color: primaryColor,
                  content: _buildEmbarazoContent(),
                ),
                _buildAccordionCard(
                  title: 'Efectos adversos',
                  icon: Icons.warning_amber_rounded,
                  color: primaryColor,
                  content: _buildEfectosContent(),
                ),
                _buildAccordionCard(
                  title: 'Generalidades',
                  icon: Icons.info_outline_rounded,
                  color: primaryColor,
                  content: _buildGeneralidadesContent(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
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

  // Métodos de contenido usando la información de 'farmaco'
  Widget _buildDosisContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildDoseBox(
            'Adulto',
            farmaco['dosisAdulto'] ?? 'Información no disponible.',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDoseBox(
            'Pediátrica',
            farmaco['dosisPediatrica'] ?? 'Información no disponible.',
          ),
        ),
      ],
    );
  }

  Widget _buildDoseBox(String title, String text) {
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
            text,
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

  Widget _buildCompatibilidadContent() {
    final compatibles = farmaco['compatibles'] as List<dynamic>? ?? [];
    final incompatibles = farmaco['incompatibles'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compatibles.isNotEmpty) ...[
          _buildSectionHeader(Icons.check_circle_outline, 'COMPATIBLE CON', const Color(0xFF43A047)),
          ...compatibles.map((e) => _buildStatusRow(Icons.check, e.toString(), const Color(0xFF43A047))),
          const SizedBox(height: 16),
        ],
        if (incompatibles.isNotEmpty) ...[
          _buildSectionHeader(Icons.cancel_outlined, 'INCOMPATIBLE CON', const Color(0xFFE53935)),
          ...incompatibles.map((e) => _buildStatusRow(Icons.close, e.toString(), const Color(0xFFE53935))),
        ],
        if (compatibles.isEmpty && incompatibles.isEmpty)
          const Text('Información sobre compatibilidad no disponible.', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, color: Color(0xFF374151))),
        ],
      ),
    );
  }

  Widget _buildPreparacionContent() {
    return Text(
      farmaco['preparacion'] ?? 'Información sobre preparación no disponible.',
      style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), height: 1.4),
    );
  }

  Widget _buildInfusionContent() {
    final tiempo = farmaco['tiempoInfusion'] ?? '--';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: Color(0xFF1E40AF), size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tiempo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const Text(
                'minutos',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmbarazoContent() {
    final categoria = farmaco['embarazoCategoria'] ?? 'N/A';
    final texto = farmaco['embarazoTexto'] ?? 'Información no disponible.';
    
    // Color según la categoría
    Color chipColor = const Color(0xFFFEF3C7);
    Color textColor = const Color(0xFF92400E);
    if (categoria.contains('A')) { chipColor = Colors.green[100]!; textColor = Colors.green[800]!; }
    else if (categoria.contains('D') || categoria.contains('X')) { chipColor = Colors.red[100]!; textColor = Colors.red[800]!; }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                'Categoría $categoria (FDA)',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          texto,
          style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildEfectosContent() {
    final graves = farmaco['efectosGraves'] as List<dynamic>? ?? [];
    final frecuentes = farmaco['efectosFrecuentes'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (graves.isNotEmpty) ...[
          const Text(
            'GRAVES',
            style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: graves.map((e) => _buildEfectoChip(e.toString(), const Color(0xFFFEE2E2), const Color(0xFF991B1B), const Color(0xFFFCA5A5))).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (frecuentes.isNotEmpty) ...[
          const Text(
            'FRECUENTES',
            style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: frecuentes.map((e) => _buildEfectoChip(e.toString(), const Color(0xFFF3F4F6), const Color(0xFF374151), const Color(0xFFD1D5DB))).toList(),
          ),
        ],
        if (graves.isEmpty && frecuentes.isEmpty)
          const Text('Información sobre efectos adversos no disponible.', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildEfectoChip(String label, Color bg, Color text, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGeneralidadesContent() {
    return Text(
      farmaco['generalidades'] ?? 'Información no disponible.',
      style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), height: 1.4),
    );
  }
}
