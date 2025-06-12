import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/land.dart';
import 'detalle_terreno_screen.dart';

class TerrenosScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const TerrenosScreen({Key? key, required this.empresaId, required this.cityId}) : super(key: key);

  @override
  State<TerrenosScreen> createState() => _TerrenosScreenState();
}

class _TerrenosScreenState extends State<TerrenosScreen> {
  bool isLoading = true;
  List<Land> terrenos = [];
  List<Land> filteredTerrenos = [];
  String searchText = '';
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadTerrenos();
  }

  Future<void> loadTerrenos() async {
    try {
      final response = await apiService.fetchTerrenosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loaded = response.map<Land>((json) => Land.fromJson(json)).toList();
      setState(() {
        terrenos = loaded;
        filteredTerrenos = loaded;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void filterTerrenos(String query) {
    setState(() {
      searchText = query.toLowerCase();
      filteredTerrenos = terrenos.where((t) {
        final title = t.title.toLowerCase();
        final descripcion = t.description.toLowerCase();
        return title.contains(searchText) || descripcion.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar terrenos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterTerrenos,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTerrenos.isEmpty
                    ? const Center(child: Text('No hay terrenos disponibles.'))
                    : ListView.builder(
                        itemCount: filteredTerrenos.length,
                        itemBuilder: (context, index) {
                          final terreno = filteredTerrenos[index];
                          final imagenUrl = terreno.images.isNotEmpty
                              ? 'http://localhost:3000${terreno.images[0]}'
                              : null;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleTerrenoScreen(terreno: terreno),
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: imagenUrl != null
                                          ? Image.network(
                                              imagenUrl,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image_not_supported, size: 50),
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            terreno.title,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            terreno.description.length > 60
                                                ? '${terreno.description.substring(0, 60)}...'
                                                : terreno.description,
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '\$${NumberFormat('#,##0.00').format(terreno.price)}',
                                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
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
