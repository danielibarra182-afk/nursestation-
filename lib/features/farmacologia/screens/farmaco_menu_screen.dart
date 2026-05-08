import 'package:flutter/material.dart';
import '../../../widgets/master_layout.dart';
import '../../../models/farmaco_model.dart';
import '../widgets/farmaco_widgets.dart';
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

  final List<Farmaco> _medications = [
    Farmaco(
      nombre: 'Ketorolaco',
      grupo: 'Analgésico / AINE',
      vias: ['IV', 'IM', 'VO'],
      categoria: 'Analgésicos',
      dosisAdulto: '15–30 mg c/6–8 h IV/IM. Máx. 120 mg/día. VO: 10 mg c/4–6 h. Máx. 5 días.',
      dosisPediatrica: '0.5 mg/kg IV/IM c/6 h (máx. 15 mg/dosis). Uso limitado en < 2 años.',
      compatibilidad: ['Sol. salina 0.9%', 'Dextrosa 5%', 'Lactato de Ringer', 'NaCl 0.45%'],
      preparacion: 'Diluir en 50–100 mL de SS 0.9% o D5%.',
      dilucion: 'Concentración máx. 0.3 mg/mL para infusión continua.',
      tiempoInfusion: '15–30',
      riesgoEmbarazo: 'C',
      efectosAdversos: ['Hemorragia GI', 'Insuficiencia renal', 'Trombocitopenia', 'Náuseas/vómitos', 'Dolor abdominal', 'Cefalea', 'Edema periférico'],
      contraindicaciones: ['Hipersensibilidad', 'Úlcera activa', 'Insuficiencia renal grave'],
      generalidades: 'AINE con potente actividad analgésica. No causa depresión respiratoria. Útil en dolor posquirúrgico moderado-severo.',
    ),
    Farmaco(
      nombre: 'Ceftriaxona',
      grupo: 'Antibiótico / Cefalosporina 3.ª gen.',
      vias: ['IV', 'IM'],
      categoria: 'Antibióticos',
      dosisAdulto: '1–2 g cada 12–24 horas. Máximo 4 g/día en infecciones graves.',
      dosisPediatrica: '50–75 mg/kg/día en 1 o 2 dosis. Máximo 2 g/día.',
      compatibilidad: ['Sol. salina 0.9%', 'Dextrosa 5%', 'Agua para inyección'],
      preparacion: 'IV directa: 1g en 10mL Agua estéril.',
      dilucion: 'Infusión: 1g en 50-100mL.',
      tiempoInfusion: '30',
      riesgoEmbarazo: 'B',
      efectosAdversos: ['Colitis pseudomembranosa', 'Anafilaxia', 'Leucopenia', 'Diarrea', 'Erupción cutánea'],
      contraindicaciones: ['Hipersensibilidad a cefalosporinas'],
      generalidades: 'Cefalosporina de amplio espectro. Excelente penetración en LCR. Vida media prolongada.',
    ),
    Farmaco(
      nombre: 'Metoprolol',
      grupo: 'Antihipertensivo / Beta-bloqueador',
      vias: ['IV', 'VO'],
      categoria: 'Cardiovascular',
      dosisAdulto: '5 mg IV lento (en 1-2 min). Puede repetirse cada 5 min hasta 15 mg.',
      dosisPediatrica: 'Seguridad no establecida en pediatría.',
      compatibilidad: ['Sol. salina 0.9%', 'Dextrosa 5%', 'Ringer Lactato'],
      preparacion: 'Administrar sin diluir o diluido.',
      dilucion: '10-20 mL de solución compatible.',
      tiempoInfusion: '2-5',
      riesgoEmbarazo: 'C',
      efectosAdversos: ['Bradicardia severa', 'Bloqueo AV', 'Broncoespasmo', 'Hipotensión', 'Mareo', 'Fatiga'],
      contraindicaciones: ['Asma bronquial', 'Bloqueo AV de 2º o 3º grado'],
      generalidades: 'Bloqueador beta-1 selectivo. Reduce la frecuencia cardíaca y el gasto cardíaco.',
    ),
  ];

  List<Farmaco> get _filteredMedications {
    return _medications.where((med) {
      final matchesCategory = _selectedCategory == 'Todos' || med.categoria == _selectedCategory;
      final matchesSearch = med.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          med.grupo.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
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
                  return FarmacoTile(
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

