import 'package:flutter/material.dart';
import '../../../widgets/master_layout.dart';

class FarmacoDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> farmaco;

  const FarmacoDetalleScreen({super.key, required this.farmaco});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterLayout(
        title: farmaco['nombre'],
        subtitle: farmaco['subtitulo'],
        primaryColor: farmaco['colorIconoFuerte'] ?? const Color(0xFF10B981),
        expandedWidget: Hero(
          tag: 'icon_${farmaco['nombre']}',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: farmaco['colorIcono'],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_outlined,
              color: farmaco['colorIconoFuerte'],
              size: 60,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Descripción', 'Este es un medicamento utilizado para ${farmaco['subtitulo'].toLowerCase()}.'),
              const SizedBox(height: 24),
              _buildSection('Vías de Administración', farmaco['rutas'].join(', ')),
              const SizedBox(height: 24),
              _buildSection('Categoría', farmaco['categoria']),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Información clínica de referencia',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF111827),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
