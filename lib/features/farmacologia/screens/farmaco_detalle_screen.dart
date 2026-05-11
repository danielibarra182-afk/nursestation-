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
                  content: _buildTiempoInfusionContent(),
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
    if (farmaco.compatibleCon.isEmpty && farmaco.incompatibleCon.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (farmaco.compatibleCon.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF43A047), size: 20),
              SizedBox(width: 10),
              Text(
                'COMPATIBLE CON',
                style: TextStyle(
                  color: Color(0xFF388E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...farmaco.compatibleCon.map((text) => _buildStatusRow(
                icon: Icons.check,
                text: text,
                color: const Color(0xFF43A047),
              )),
          const SizedBox(height: 24),
        ],
        if (farmaco.incompatibleCon.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.block_flipped, color: Color(0xFFE64A19), size: 20),
              SizedBox(width: 10),
              Text(
                'INCOMPATIBLE CON',
                style: TextStyle(
                  color: Color(0xFFE64A19),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...farmaco.incompatibleCon.map((text) => _buildStatusRow(
                icon: Icons.close,
                text: text,
                color: const Color(0xFFE64A19),
              )),
        ],
      ],
    );
  }

  Widget _buildStatusRow({required IconData icon, required String text, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16, 
                color: Color(0xFF111827),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparacionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (farmaco.preparacionBolus.isNotEmpty || farmaco.dilucionBolus.isNotEmpty) ...[
          const Text('BOLO / ADMINISTRACIÓN DIRECTA:', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          if (farmaco.preparacionBolus.isNotEmpty) 
            Text(farmaco.preparacionBolus, style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
          if (farmaco.dilucionBolus.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Dilución: ${farmaco.dilucionBolus}', style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
            ),
          const SizedBox(height: 16),
        ],
        if (farmaco.preparacionInfusion.isNotEmpty || farmaco.dilucionInfusion.isNotEmpty) ...[
          const Text('INFUSIÓN INTERMITENTE / CONTINUA:', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          if (farmaco.preparacionInfusion.isNotEmpty) 
            Text(farmaco.preparacionInfusion, style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
          if (farmaco.dilucionInfusion.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Dilución: ${farmaco.dilucionInfusion}', style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
            ),
        ],
        if (farmaco.preparacionBolus.isEmpty && farmaco.dilucionBolus.isEmpty && 
            farmaco.preparacionInfusion.isEmpty && farmaco.dilucionInfusion.isEmpty)
          const Text('Información no disponible', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTiempoInfusionContent() {
    if (farmaco.tiempoBolus.isEmpty && farmaco.tiempoInfusion.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }

    return Column(
      children: [
        if (farmaco.tiempoBolus.isNotEmpty) ...[
          InfusionBox(title: 'Bolo / Directo', content: farmaco.tiempoBolus),
          if (farmaco.tiempoInfusion.isNotEmpty) const SizedBox(height: 12),
        ],
        if (farmaco.tiempoInfusion.isNotEmpty)
          InfusionBox(title: 'Infusión', content: farmaco.tiempoInfusion),
      ],
    );
  }

  Widget _buildEfectosContent() {
    if (farmaco.efectosGraves.isEmpty && farmaco.efectosFrecuentes.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (farmaco.efectosGraves.isNotEmpty) ...[
          const Text('GRAVES', style: TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: farmaco.efectosGraves.map((e) => GenericChip(label: e, color: const Color(0xFF991B1B))).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (farmaco.efectosFrecuentes.isNotEmpty) ...[
          const Text('FRECUENTES', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: farmaco.efectosFrecuentes.map((e) => GenericChip(label: e, color: const Color(0xFF4B5563))).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildContraindicacionesContent() {
    if (farmaco.contraindicaciones.isEmpty) {
      return const Text('Información no disponible', style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: farmaco.contraindicaciones.map((e) => StatusRow(icon: Icons.block_flipped, text: e, color: const Color(0xFF991B1B))).toList(),
    );
  }
}
