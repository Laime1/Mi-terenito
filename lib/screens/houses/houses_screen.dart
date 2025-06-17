import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/house.dart';
import 'details_house_screen.dart';
import '../home2_screen.dart'; // Asegúrate de importar la pantalla Home2Screen

class HousesScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const HousesScreen({Key? key, required this.empresaId, required this.cityId}) : super(key: key);

  @override
  State<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
  bool isLoading = true;
  List<dynamic> casas = [];
  List<dynamic> filteredCasas = [];
  String searchText = '';

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadCasas();
  }

  Future<void> loadCasas() async {
    try {
      final loadedCasas = await apiService.fetchCasasByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        casas = loadedCasas;
        filteredCasas = loadedCasas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCasas(String query) {
    setState(() {
      searchText = query.toLowerCase();
      filteredCasas = casas.where((casa) {
        final title = casa['titulo']?.toLowerCase() ?? '';
        final ciudad = casa['ciudad']?['nombre_ciudad']?.toLowerCase() ?? '';
        return title.contains(searchText) || ciudad.contains(searchText);
      }).toList();
    });
  }

  void navigateTo(String tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Home2Screen(
          tipo: tipo,
          empresaId: widget.empresaId,
          cityId: widget.cityId,
        ),
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔍 Buscador
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar casas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterCasas,
            ),
          ),

          // 🏠 Lista de casas
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCasas.isEmpty
                    ? const Center(child: Text('No hay casas disponibles.'))
                    : ListView.builder(
                        itemCount: filteredCasas.length,
                        itemBuilder: (context, index) {
                          final casa = filteredCasas[index];
                          final imagenUrl = (casa['imagenes'] != null && casa['imagenes'].isNotEmpty)
                              ? 'http://localhost:3000${casa['imagenes'][0]}'
                              : null;
                          final ciudad = casa['ciudad'] ?? {};

                          return GestureDetector(
                            onTap: () {
                              final houseModel = House.fromJson(casa);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsHouseScreen(casa: houseModel),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imagenUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          imagenUrl,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            casa['titulo'] ?? 'Sin título',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  ciudad['nombre_ciudad'] ?? '-',
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.king_bed, size: 20),
                                              const SizedBox(width: 4),
                                              Text('${casa['habitaciones'] ?? '-'} hab'),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.bathtub, size: 20),
                                              const SizedBox(width: 4),
                                              Text('${casa['banos'] ?? '-'} baños'),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '\$${casa['precio'] ?? '-'}',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
