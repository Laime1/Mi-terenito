import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/property/property.dart';
import 'package:mi_terrenito/screens/form_screen.dart';
import '../widgets/card_lands.dart';

class LandScreen extends StatefulWidget {
  final List<Property> properties;

  const LandScreen({super.key, required this.properties});

  @override
  LandScreenState createState() => LandScreenState();
}

class LandScreenState extends State<LandScreen> {
  TextEditingController searchController = TextEditingController();
  List<Property> filteredProperties = [];

  @override
  void initState() {
    super.initState();
    filteredProperties = widget.properties;
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
      filteredProperties = widget.properties.where((property) {
        final title = property.name?.toLowerCase() ?? '';
        final description = property.description?.toLowerCase() ?? '';
        final price = property.maxPrice.toString() ?? '0';
        return title.contains(query) ||
            description.contains(query) ||
            price.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('TERRENOS', style: TextStyle(fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar terrenos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
              child: searchController.text.isEmpty
                  ? const CircularProgressIndicator()
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormScreen()),
            );
          },
      ),
    );
  }
}