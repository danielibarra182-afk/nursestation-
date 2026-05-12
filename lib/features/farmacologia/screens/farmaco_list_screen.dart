import 'package:flutter/material.dart';
import '../../../widgets/master_layout.dart';
import '../../../models/farmaco_model.dart';
import '../../../services/farmaco_service.dart';
import '../widgets/farmaco_widgets.dart';
import 'farmaco_detalle_screen.dart';

class FarmacoListScreen extends StatefulWidget {
  const FarmacoListScreen({super.key});

  @override
  State<FarmacoListScreen> createState() => _FarmacoListScreenState();
}

class _FarmacoListScreenState extends State<FarmacoListScreen> {
  final FarmacoService _farmacoService = FarmacoService();
  
  List<Farmaco> _allFarmacos = [];
  List<Farmaco> _filteredFarmacos = [];
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  bool _isLoading = true;

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
    'Antivirales',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final farmacos = await _farmacoService.cargarMedicamentos();
    _allFarmacos = farmacos;
    _applyFiltersInternal(); // Llamamos a la lógica sin setState interno
    setState(() {
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _applyFiltersInternal();
    });
  }

  void _applyFiltersInternal() {
    _filteredFarmacos = _allFarmacos.where((med) {
      String categorySearch = _selectedCategory.toLowerCase();
      if (categorySearch != 'todos') {
        if (categorySearch.endsWith('es')) {
          categorySearch = categorySearch.substring(0, categorySearch.length - 2);
        } else if (categorySearch.endsWith('s')) {
          categorySearch = categorySearch.substring(0, categorySearch.length - 1);
        }
      }

      final matchesCategory = _selectedCategory == 'Todos' || 
          med.categoria.toLowerCase().contains(categorySearch) ||
          (_selectedCategory == 'Antivirales' && med.categoria.toLowerCase().contains('antirretroviral')); 
      
      final matchesSearch = med.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          med.grupo.toLowerCase().contains(_searchQuery.toLowerCase());
          
      return matchesCategory && matchesSearch;
    }).toList();
    
    _filteredFarmacos.sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      title: 'Farmacología',
      subtitle: 'Compendio de medicamentos',
      icon: Icons.vaccines_rounded,
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Buscador
            _buildSearchBar(),
            const SizedBox(height: 20),
            
            // Selector de Categorías
            _buildCategorySelector(),
            const SizedBox(height: 20),
            
            // Lista de Fármacos
            Expanded(
              child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  )
                : _filteredFarmacos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80), // Espacio para el FAB
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredFarmacos.length,
                      itemBuilder: (context, index) {
                        final med = _filteredFarmacos[index];
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          _searchQuery = value;
          _applyFilters();
        },
        decoration: InputDecoration(
          hintText: 'Buscar fármaco o grupo...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                  _applyFilters();
                });
              },
              selectedColor: const Color(0xFF10B981).withOpacity(0.2),
              checkmarkColor: const Color(0xFF10B981),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF075E54) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF10B981) : Colors.grey[300]!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No se encontraron fármacos',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
