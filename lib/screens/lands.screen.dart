import 'package:flutter/material.dart';
import '../models/property/property.dart';
import '../widgets/card_lands.dart';
import 'form_screen.dart';

class LandsScreen extends StatefulWidget {
  final List<Property> properties;
  final int? idUsuario;
  const LandsScreen({super.key, required this.properties, required this.idUsuario});

  @override
  State<LandsScreen> createState() => _LandsScreenState();
}

class _LandsScreenState extends State<LandsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Property> filteredProperties = [];
  List<Property> landProperties = [];

  @override
  void initState() {
    super.initState();
    landProperties = widget.properties.where((p) => p.isLand()).toList();
    filteredProperties = landProperties;
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
      filteredProperties = landProperties.where((property) {
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
          Text('TERRENOS', style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar terrenos...',
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
                    child: landProperties.isEmpty
                        ? const Text('No cuentas con propiedades en esta área (Terrenos)')
                        : const Text('No se encontraron resultados'),
                  )
                : ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = filteredProperties[index];
                      return PropertyCard(
                        property: property,
                        idUsuario: widget.idUsuario,
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