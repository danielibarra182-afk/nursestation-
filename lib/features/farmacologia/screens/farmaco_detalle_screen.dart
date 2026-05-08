import 'package:flutter/material.dart';
import '../../../models/farmaco_model.dart';
import '../widgets/farmaco_widgets.dart';

class FarmacoDetalleScreen extends StatelessWidget {
  final Farmaco farmaco;

  const FarmacoDetalleScreen({super.key, required this.farmaco});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF10B981); // Color verde médico de la app

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      body: Column(
        children: [
          // Header
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
                  farmaco.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  farmaco.grupo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: farmaco.vias.map((ruta) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ruta,
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

          // Cuerpo con Accordions Reutilizables
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                FarmacoAccordion(
                  title: 'Dosis',
                  icon: Icons.balance_rounded,
                  color: primaryColor,
                  content: _buildDosisContent(),
                ),
                FarmacoAccordion(
                  title: 'Compatibilidad IV',
                  icon: Icons.swap_vert_rounded,
                  color: primaryColor,
                  content: _buildCompatibilidadContent(),
                ),
                FarmacoAccordion(
                  title: 'Preparación / Dilución',
                  icon: Icons.science_outlined,
                  color: primaryColor,
                  content: _buildPreparacionContent(),
                ),
                FarmacoAccordion(
                  title: 'Tiempo de infusión',
                  icon: Icons.access_time_rounded,
                  color: primaryColor,
                  content: InfusionBox(minutes: farmaco.tiempoInfusion),
                ),
                FarmacoAccordion(
                  title: 'Riesgo en el embarazo',
                  icon: Icons.child_friendly_rounded,
                  color: primaryColor,
                  content: PregnancyCategoryChip(category: farmaco.riesgoEmbarazo),
                ),
                FarmacoAccordion(
                  title: 'Efectos adversos',
                  icon: Icons.warning_amber_rounded,
                  color: primaryColor,
                  content: _buildEfectosContent(),
                ),
                FarmacoAccordion(
                  title: 'Contraindicaciones',
                  icon: Icons.block_flipped,
                  color: primaryColor,
                  content: _buildContraindicacionesContent(),
                ),
                FarmacoAccordion(
                  title: 'Generalidades',
                  icon: Icons.info_outline_rounded,
                  color: primaryColor,
                  content: Text(
                    farmaco.generalidades.isEmpty ? 'Información no disponible' : farmaco.generalidades,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937), height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosisContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: DoseBox(title: 'Adulto', text: farmaco.dosisAdulto)),
        const SizedBox(width: 10),
        Expanded(child: DoseBox(title: 'Pediátrica', text: farmaco.dosisPediatrica)),
      ],
    );
  }

  Widget _buildCompatibilidadContent() {
    if (farmaco.compatibilidad.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: farmaco.compatibilidad.map((text) => StatusRow(icon: Icons.check, text: text, color: const Color(0xFF43A047))).toList(),
    );
  }

  Widget _buildPreparacionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (farmaco.preparacion.isNotEmpty) ...[
          const Text('PREPARACIÓN:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
          const SizedBox(height: 4),
          Text(farmaco.preparacion, style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
          const SizedBox(height: 12),
        ],
        if (farmaco.dilucion.isNotEmpty) ...[
          const Text('DILUCIÓN:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
          const SizedBox(height: 4),
          Text(farmaco.dilucion, style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
        ],
        if (farmaco.preparacion.isEmpty && farmaco.dilucion.isEmpty)
          const Text('Información no disponible', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildEfectosContent() {
    if (farmaco.efectosAdversos.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: farmaco.efectosAdversos.map((e) => GenericChip(label: e, color: Colors.red[800]!)).toList(),
    );
  }

  Widget _buildContraindicacionesContent() {
    if (farmaco.contraindicaciones.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: farmaco.contraindicaciones.map((e) => StatusRow(icon: Icons.stop_circle_outlined, text: e, color: Colors.red)).toList(),
    );
  }
}
