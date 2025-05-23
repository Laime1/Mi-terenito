import 'package:flutter/material.dart';
import '../models/property/property.dart';
import '../widgets/card_lands.dart';
import 'form_screen.dart';

class HousesScreen extends StatefulWidget {
  final List<Property> properties;
  final int? idUsuario;

  const HousesScreen({super.key, required this.properties, required this.idUsuario});

  @override
  State<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
  TextEditingController searchController = TextEditingController();
  List<Property> filteredProperties = [];
  List<Property> houseProperties = [];

  @override
  void initState() {
    super.initState();
    houseProperties = widget.properties.where((p) => p.isHouse()).toList();
    filteredProperties = houseProperties;
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
      filteredProperties = houseProperties.where((property) {
        final title = property.name.toLowerCase();
        final description = property.description.toLowerCase();
        final price = property.maxPrice.toString();
        return title.contains(query) || description.contains(query) || price.contains(query);
      }).toList();
    });
  }

  void _mostrarDialogoPremium(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Acceso restringido"),
        content: const Text("Debes convertirte en usuario premium para acceder a esta funcionalidad."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text('CASAS', style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar casas...',
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
                    child: houseProperties.isEmpty
                        ? const Text('No cuentas con propiedades en esta área (Casas)')
                        : const Text('No se encontraron resultados'),
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
          ? (widget.idUsuario == 2
              ? FloatingActionButton(
                  onPressed: () {
                    _mostrarDialogoPremium(context);
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.lock),
                  tooltip: 'Acceso restringido',
                )
              : FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormScreen(type: 1, idUser: widget.idUsuario!),
                      ),
                    );
                  },
                ))
          : null,
    );
  }
}
