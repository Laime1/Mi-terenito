import 'package:flutter/material.dart';
import '../models/property/property.dart';
import '../widgets/card_lands.dart';
import 'form_screen.dart';

class RentalsScreen extends StatefulWidget {
  final List<Property> properties;
  final int? idUsuario;
  const RentalsScreen({super.key, required this.properties, required this.idUsuario});

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Property> filteredProperties = [];
  List<Property> rentalProperties = [];

  @override
  void initState() {
    super.initState();
    rentalProperties = widget.properties.where((p) => p.isRental()).toList();
    filteredProperties = rentalProperties;
    searchController.addListener(_filterProperties);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterProperties() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProperties = rentalProperties.where((property) {
        final title = property.name.toLowerCase();
        final description = property.description.toLowerCase();
        final price = property.maxPrice.toString();
        return title.contains(query) || description.contains(query) || price.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ALQUILERES', style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar alquileres...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredProperties.isEmpty
                ? Center(
                    child: rentalProperties.isEmpty
                        ? const Text('No cuentas con propiedades en esta área (Alquileres)')
                        : const Text('No se encontraron resultados'),
                  )
                : ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = filteredProperties[index];
                      return PropertyCard(property: property);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.idUsuario != null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
              },
            )
          : null,
    );
  }
}