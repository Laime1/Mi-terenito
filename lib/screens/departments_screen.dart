import 'package:flutter/material.dart';
import '../models/app_colors.dart';
import '../models/property/property.dart';
import '../widgets/card_lands.dart';
import 'form_screen.dart';

class DepartmentsScreen extends StatefulWidget {
  final List<Property> properties;
  final int? idUsuario;

  const DepartmentsScreen({super.key, required this.properties, this.idUsuario});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Property> filteredProperties = [];
  List<Property> departmentProperties = [];

  @override
  void initState() {
    super.initState();
    
    departmentProperties = widget.properties.where((p) => p.isDepartment()).toList();
    filteredProperties = departmentProperties;
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
      filteredProperties = departmentProperties.where((property) {
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
      backgroundColor: AppColors.bodyBackground,
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'DEPARTAMENTOS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar departamentos...',
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
                    child: departmentProperties.isEmpty
                        ? const Text(
                            'No cuentas con propiedades en esta área (Departamentos)',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'No se encontraron resultados',
                            style: TextStyle(color: Colors.white),
                          ),
                  )
                : ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = filteredProperties[index];
                      return PropertyCard(property: property, idUsuario: widget.idUsuario);
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
                  MaterialPageRoute(
                    builder: (context) => FormScreen(type: 4, idUser: widget.idUsuario!), 
                  ),
                );
              },
            )
          : null,
    );
  }
}
