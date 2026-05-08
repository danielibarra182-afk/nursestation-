import 'package:flutter/material.dart';
import '../../../widgets/master_layout.dart';
import 'farmaco_detalle_screen.dart';

class FarmacoMenuScreen extends StatefulWidget {
  const FarmacoMenuScreen({super.key});

  @override
  State<FarmacoMenuScreen> createState() => _FarmacoMenuScreenState();
}

class _FarmacoMenuScreenState extends State<FarmacoMenuScreen> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Todos',
    'Analgésicos',
    'Antibióticos',
    'Cardiovascular',
    'Digestivos',
    'Anticoagulantes',
    'Esteroides',
    'Soluciones',
    'Electrolitos',
    'Endocrinología',
    'Neumología',
    'Neurología',
  ];

  final List<Map<String, dynamic>> _medications = [
    {
      'nombre': 'Ketorolaco',
      'subtitulo': 'Analgésico / AINE',
      'rutas': ['IV', 'IM', 'VO'],
      'categoria': 'Analgésicos',
      'colorIcono': const Color(0xFFFFF3E0),
      'colorIconoFuerte': const Color(0xFFE65100),
      'dosisAdulto': '15–30 mg c/6–8 h IV/IM. Máx. 120 mg/día. VO: 10 mg c/4–6 h. Máx. 5 días.',
      'dosisPediatrica': '0.5 mg/kg IV/IM c/6 h (máx. 15 mg/dosis). Uso limitado en < 2 años.',
      'compatibles': ['Sol. salina 0.9%', 'Dextrosa 5%', 'Lactato de Ringer', 'NaCl 0.45%'],
      'incompatibles': ['Morfina', 'Prometazina', 'Haloperidol', 'Solución de bicarbonato'],
      'preparacion': 'Diluir en 50–100 mL de SS 0.9% o D5%. Concentración máx. 0.3 mg/mL para infusión continua.',
      'tiempoInfusion': '15–30',
      'embarazoCategoria': 'C',
      'embarazoTexto': 'Contraindicado en 3.er trimestre (cierre prematuro del ducto arterioso). Usar con precaución en 1.º y 2.º trimestre.',
      'efectosGraves': ['Hemorragia GI', 'Insuficiencia renal', 'Trombocitopenia'],
      'efectosFrecuentes': ['Náuseas/vómitos', 'Dolor abdominal', 'Cefalea', 'Edema periférico'],
      'generalidades': 'AINE con potente actividad analgésica. No causa depresión respiratoria. Útil en dolor posquirúrgico moderado-severo.',
    },
    {
      'nombre': 'Ceftriaxona',
      'subtitulo': 'Antibiótico / Cefalosporina 3.ª gen.',
      'rutas': ['IV', 'IM'],
      'categoria': 'Antibióticos',
      'colorIcono': const Color(0xFFE0F2F1),
      'colorIconoFuerte': const Color(0xFF00695C),
      'dosisAdulto': '1–2 g cada 12–24 horas. Máximo 4 g/día en infecciones graves.',
      'dosisPediatrica': '50–75 mg/kg/día en 1 o 2 dosis. Máximo 2 g/día.',
      'compatibles': ['Sol. salina 0.9%', 'Dextrosa 5%', 'Agua para inyección'],
      'incompatibles': ['Soluciones con Calcio (Ringer Lactato)', 'Fluconazol', 'Vancomicina'],
      'preparacion': 'IV directa: 1g en 10mL Agua estéril en 2-4 min. Infusión: 1g en 50-100mL.',
      'tiempoInfusion': '30',
      'embarazoCategoria': 'B',
      'embarazoTexto': 'No se han demostrado riesgos en el feto humano. Usar solo si es claramente necesario.',
      'efectosGraves': ['Colitis pseudomembranosa', 'Anafilaxia', 'Leucopenia'],
      'efectosFrecuentes': ['Diarrea', 'Erupción cutánea', 'Dolor en sitio de inyección'],
      'generalidades': 'Cefalosporina de amplio espectro. Excelente penetración en LCR. Vida media prolongada.',
    },
    {
      'nombre': 'Metoprolol',
      'subtitulo': 'Antihipertensivo / Beta-bloqueador',
      'rutas': ['IV', 'VO'],
      'categoria': 'Cardiovascular',
      'colorIcono': const Color(0xFFE3F2FD),
      'colorIconoFuerte': const Color(0xFF1565C0),
      'dosisAdulto': '5 mg IV lento (en 1-2 min). Puede repetirse cada 5 min hasta 15 mg.',
      'dosisPediatrica': 'Seguridad no establecida en pediatría.',
      'compatibles': ['Sol. salina 0.9%', 'Dextrosa 5%', 'Ringer Lactato'],
      'incompatibles': ['Anfotericina B', 'Furosemida'],
      'preparacion': 'Administrar sin diluir o diluido en 10-20 mL de solución compatible.',
      'tiempoInfusion': '2-5',
      'embarazoCategoria': 'C',
      'embarazoTexto': 'Puede causar bradicardia fetal e hipoglucemia. Usar bajo vigilancia estricta.',
      'efectosGraves': ['Bradicardia severa', 'Bloqueo AV', 'Broncoespasmo'],
      'efectosFrecuentes': ['Hipotensión', 'Mareo', 'Fatiga'],
      'generalidades': 'Bloqueador beta-1 selectivo. Reduce la frecuencia cardíaca y el gasto cardíaco.',
    },
    {
      'nombre': 'Omeprazol',
      'subtitulo': 'Antiulceroso / IBP',
      'rutas': ['IV', 'VO'],
      'categoria': 'Digestivos',
      'colorIcono': const Color(0xFFF3E5F5),
      'colorIconoFuerte': const Color(0xFF7B1FA2),
    },
    {
      'nombre': 'Enoxaparina',
      'subtitulo': 'Anticoagulante / HBPM',
      'rutas': ['SC', 'IV'],
      'categoria': 'Anticoagulantes',
      'colorIcono': const Color(0xFFFFEBEE),
      'colorIconoFuerte': const Color(0xFFC62828),
    },
    {
      'nombre': 'Dexametasona',
      'subtitulo': 'Corticosteroide / Antiinflamatorio',
      'rutas': ['IV', 'IM', 'VO'],
      'categoria': 'Esteroides',
      'colorIcono': const Color(0xFFE8EAF6),
      'colorIconoFuerte': const Color(0xFF283593),
    },
    {
      'nombre': 'Solución Salina 0.9%',
      'subtitulo': 'Solución Isotónica / Cristaloides',
      'rutas': ['IV'],
      'categoria': 'Soluciones',
      'colorIcono': const Color(0xFFE0F7FA),
      'colorIconoFuerte': const Color(0xFF00838F),
    },
    {
      'nombre': 'Gluconato de Calcio',
      'subtitulo': 'Electrolito / Suplemento Mineral',
      'rutas': ['IV'],
      'categoria': 'Electrolitos',
      'colorIcono': const Color(0xFFFFFDE7),
      'colorIconoFuerte': const Color(0xFFF9A825),
    },
  ];

  List<Map<String, dynamic>> get _filteredMedications {
    final filtered = _medications.where((med) {
      final matchesCategory = _selectedCategory == 'Todos' || med['categoria'] == _selectedCategory;
      final matchesSearch = med['nombre'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          med['subtitulo'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Ordenar alfabéticamente por nombre
    filtered.sort((a, b) => (a['nombre'] as String).compareTo(b['nombre'] as String));
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      title: 'Medicamentos',
      subtitle: 'Consulta rápida hospitalaria',
      primaryColor: const Color(0xFF10B981), // Color verde médico
      expandedWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.vaccines_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Medicamentos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Buscar medicamento...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  ),
                ),
              ),
            ),
  
            // Selector de Categorías
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE0F2F1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF10B981) : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF00695C) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
  
            const SizedBox(height: 24),
  
            // Contador de Medicamentos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_filteredMedications.length} RESULTADOS',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
  
            const SizedBox(height: 12),
  
            // Lista de Medicamentos
            if (_filteredMedications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No se encontraron medicamentos',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredMedications.length,
                itemBuilder: (context, index) {
                  final med = _filteredMedications[index];
                  return _MedicationTile(
                    med: med,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmacoDetalleScreen(farmaco: med),
                        ),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _MedicationTile extends StatelessWidget {
  final Map<String, dynamic> med;
  final VoidCallback onTap;

  const _MedicationTile({
    required this.med,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                // Icono Izquierdo
                Hero(
                  tag: 'icon_${med['nombre']}',
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: med['colorIcono'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medication_outlined,
                      color: med['colorIconoFuerte'],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información Central
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med['nombre'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        med['subtitulo'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Chips de Rutas y Categoría
                      Wrap(
                        spacing: 6,
                        children: [
                          ...List<String>.from(med['rutas']).map((ruta) => _buildRouteChip(ruta)),
                          _buildCategoryChip(med['categoria']),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron Derecho
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRouteChip(String text) {
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

  Widget _buildCategoryChip(String text) {
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
