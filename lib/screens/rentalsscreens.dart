import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/rent.dart';

class Rentals1Screen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const Rentals1Screen({
    Key? key,
    required this.empresaId,
    required this.cityId,
  }) : super(key: key);

  @override
  State<Rentals1Screen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<Rentals1Screen> {
  bool isLoading = true;
  List<dynamic> rentals = [];
  List<dynamic> filteredRentals = [];
  String searchText = '';

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadRentals();
  }

  Future<void> loadRentals() async {
    try {
      final loadedRentals = await apiService.fetchAlquileresByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        rentals = loadedRentals;
        filteredRentals = loadedRentals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterRentals(String query) {
    setState(() {
      searchText = query.toLowerCase();
      filteredRentals = rentals.where((rental) {
        final title = rental['titulo']?.toLowerCase() ?? '';
        final description = rental['descripcion']?.toLowerCase() ?? '';
        final priceStr = rental['precio_mes']?.toString() ?? '';
        return title.contains(searchText) || description.contains(searchText) || priceStr.contains(searchText);
      }).toList();
    });
  }

  String formatPrice(dynamic price) {
    if (price == null) return 'Precio no disponible';
    try {
      return '\$${NumberFormat('#,###').format(price)} / mes';
    } catch (_) {
      return '\$${price.toString()} / mes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar alquileres...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterRentals,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRentals.isEmpty
                    ? const Center(child: Text('No hay alquileres disponibles.'))
                    : ListView.builder(
                        itemCount: filteredRentals.length,
                        itemBuilder: (context, index) {
                          final rental = filteredRentals[index];
                          final imagenUrl = (rental['imagenes'] != null && rental['imagenes'].isNotEmpty)
                              ? 'http://localhost:3000${rental['imagenes'][0]}'
                              : null;

                          return GestureDetector(
                            onTap: () {
                              // Puedes navegar al detalle si implementas pantalla de detalle
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
                                            rental['titulo'] ?? 'Sin título',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            rental['descripcion'] ?? 'Sin descripción',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            formatPrice(rental['precio_mes']),
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
