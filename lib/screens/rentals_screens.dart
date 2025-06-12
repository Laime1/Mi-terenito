import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rent.dart';

class RentalsScreen extends StatefulWidget {
  final List<Rental> rentals;
  final int? idUsuario;

  const RentalsScreen({super.key, required this.rentals, required this.idUsuario});

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Rental> filteredRentals = [];

  @override
  void initState() {
    super.initState();
    filteredRentals = widget.rentals;
    searchController.addListener(_filterRentals);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterRentals() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRentals = widget.rentals.where((rental) {
        final title = rental.title?.toLowerCase() ?? '';
        final description = rental.description?.toLowerCase() ?? '';
        final price = rental.monthlyPrice?.toString() ?? '';
        return title.contains(query) || description.contains(query) || price.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alquileres')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar alquileres...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchController.clear(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredRentals.isEmpty
                ? Center(
                    child: widget.rentals.isEmpty
                        ? const Text('No cuentas con propiedades en esta área (Alquileres)')
                        : const Text('No se encontraron resultados'),
                  )
                : ListView.builder(
                    itemCount: filteredRentals.length,
                    itemBuilder: (context, index) {
                      final rental = filteredRentals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/alquiler.jpg', // Usa imagen local o cambia por red si tienes URL
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rental.title ?? 'Sin título',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      (rental.description?.length ?? 0) > 60  // ✅ Correcto

                                          ? '${rental.description!.substring(0, 60)}...'
                                          : (rental.description ?? 'Sin descripción'),
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      rental.monthlyPrice != null
                                          ? '\$${NumberFormat('#,###').format(rental.monthlyPrice)} / mes'
                                          : 'Precio no disponible',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.idUsuario != null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                // Puedes agregar aquí la lógica para agregar alquiler
              },
            )
          : null,
    );
  }
}
