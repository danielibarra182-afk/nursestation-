import 'package:flutter/material.dart';

class AgregarPacienteScreen extends StatelessWidget {
  const AgregarPacienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color turquesa = Color(0xFF40E0D0); // Turquesa #40E0D0
    
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo casi blanco
      appBar: AppBar(
        title: const Text('Kardex'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 1, // Elevación muy baja para verse moderno
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Bordes bien redondeados
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Encabezado ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Nombre del Paciente',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: turquesa,
                              borderRadius: BorderRadius.circular(20), // Contenedor redondeado
                            ),
                            child: const Text(
                              'Cama 01',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Cuerpo de Datos: Edad, Género, Estancia ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Edad', '45 años'),
                          _buildInfoColumn('Género', 'Masc.'),
                          _buildInfoColumn(
                            'Días estancia',
                            '3',
                            highlightVal: true,
                            turquesa: turquesa,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Cuerpo de Datos: Diagnóstico ---
                      const Text(
                        'Diagnóstico',
                        style: TextStyle(
                          color: Colors.black54, // Texto gris oscuro
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: turquesa.withOpacity(0.05), // Bloque que destaque de manera sutil
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: turquesa.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'Diagnóstico de ejemplo...',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Botones Inferiores ---
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.medication_outlined, size: 20, color: turquesa), // Iconos lineales
                              label: const Text(
                                'Ver Medicamentos',
                                style: TextStyle(color: turquesa, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: turquesa),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // Bordes muy redondeados
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.insert_drive_file_outlined, size: 20, color: Colors.black54),
                            label: const Text(
                              'Notas',
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool highlightVal = false, Color? turquesa}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54, // Gris oscuro
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlightVal && turquesa != null ? turquesa : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
