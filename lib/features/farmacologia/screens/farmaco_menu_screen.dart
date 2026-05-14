import 'package:flutter/material.dart';
import '../../../widgets/master_layout.dart';
import '../../../models/farmaco_model.dart';
import '../../../services/farmaco_service.dart';
import '../widgets/farmaco_widgets.dart';
import '../utils/farmaco_ui_utils.dart';
import 'farmaco_detalle_screen.dart';

class FarmacoMenuScreen extends StatefulWidget {
  const FarmacoMenuScreen({super.key});

  @override
  State<FarmacoMenuScreen> createState() => _FarmacoMenuScreenState();
}

class _FarmacoMenuScreenState extends State<FarmacoMenuScreen> {
  final FarmacoService _farmacoService = FarmacoService();
  final TextEditingController _searchController = TextEditingController();

  List<Farmaco> _allMedications = [];
  List<Farmaco> _filteredMedications = [];
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  bool _isLoading = true;

  final List<String> _categories = [
    'Todos',
    'Analgésicos',
    'Sedantes y anestésicos',
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
    'Antivirales',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final meds = await _farmacoService.cargarMedicamentos();
      _allMedications = meds;
      _applyFiltersInternal();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error cargando medicamentos: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      _applyFiltersInternal();
    });
  }

  void _applyFiltersInternal() {
    // Normalización de categoría para búsqueda flexible (singular/plural)
    String categorySearch = _selectedCategory.toLowerCase();
    if (categorySearch != 'todos') {
      if (categorySearch.endsWith('es')) {
        categorySearch = categorySearch.substring(0, categorySearch.length - 2);
      } else if (categorySearch.endsWith('s')) {
        categorySearch = categorySearch.substring(0, categorySearch.length - 1);
      }
    }

    _filteredMedications = _allMedications.where((med) {
      final matchesCategory = _selectedCategory == 'Todos' ||
          med.categoria.toLowerCase().contains(categorySearch) ||
          (_selectedCategory == 'Antivirales' &&
              med.categoria.toLowerCase().contains('antirretroviral'));

      final matchesSearch =
          med.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              med.grupo.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    _filteredMedications.sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      title: 'Medicamentos',
      subtitle: 'Consulta rápida hospitalaria',
      primaryColor: const Color(0xFF10B981),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
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
                  _searchQuery = value;
                  _applyFilters();
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar medicamento...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                final categoryColor = category == 'Todos' 
                    ? const Color(0xFF10B981) 
                    : getFarmacoColor(category);
                final contrastColor = isSelected 
                    ? FarmacoUIUtils.getContrastColor(categoryColor) 
                    : Colors.black87;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _applyFilters();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? categoryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? categoryColor
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ] : null,
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: contrastColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Contador y Resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _isLoading
                  ? 'CARGANDO...'
                  : '${_filteredMedications.length} RESULTADOS',
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
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF10B981)))
                : _filteredMedications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
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
                                  builder: (context) =>
                                      FarmacoDetalleScreen(farmaco: med),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
