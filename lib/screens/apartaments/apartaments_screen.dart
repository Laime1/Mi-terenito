import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_detail_screen.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_form_screen.dart';
import 'package:mi_terrenito/widgets/loader_overlay.dart';
import 'package:mi_terrenito/services/api_service.dart';
import '../../models/apartment.dart';
import '../../widgets/card_apartament.dart';

class ApartmentsScreen extends StatefulWidget {
  final int companyId;
  final int cityId;
  final int? userId;

  const ApartmentsScreen({
    super.key,
    required this.companyId,
    required this.cityId,
    required this.userId,
  });

  @override
  State<ApartmentsScreen> createState() => _ApartmentsScreenState();
}

class _ApartmentsScreenState extends State<ApartmentsScreen> {
  late TextEditingController searchController;
  List<Apartment> filteredApartments = [];
  List<Apartment> allApartments = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadApartments();
    searchController.addListener(_filterApartments);
  }

  Future<void> _loadApartments() async {
    try {
      final List<Apartment> apartments;

      widget.userId != null
          ? apartments = await ApiService.fetchDepartamentosByUsuario(
            widget.userId!,
          )
          : apartments = await ApiService.getApartmentsByCompanyAndCity(
            companyId: widget.companyId,
            cityId: widget.cityId,
          );

      setState(() {
        allApartments = apartments;
        filteredApartments = apartments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void _filterApartments() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredApartments =
          allApartments.where((apt) {
            return apt.title.toLowerCase().contains(query) ||
                apt.description.toLowerCase().contains(query) ||
                apt.price.toString().contains(query);
          }).toList();
    });
  }

  Future<void> _deleteApartment(int id, BuildContext context) async {
    try {
      final success = await ApiService.deleteApartment(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Departamento desactivado correctamente')),
        );
        _loadApartments(); // Recargar la lista
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _editApartment(Apartment apartment, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentFormScreen(
          idUser: widget.userId!,
          idCity: widget.cityId, // Corregido: usar el cityId del widget
          apartment: apartment,
        ),
      ),
    ).then((_) => _loadApartments()); // Recargar después de editar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar departamentos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchController.clear(),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const HouseLoader()
                    : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : filteredApartments.isEmpty
                    ? Center(
                      child: Text(
                        widget.userId != null
                            ? 'Sin departamentos publicados.'
                            : 'No hay departamentos disponibles.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredApartments.length,
                      itemBuilder: (context, index) {
                        final Apartment apartment = filteredApartments[index];
                        return ApartmentCard(
                          apartment: apartment,
                          enableSwipeActions: widget.userId != null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApartmentDetailScreen(
                                  apartment: apartment,
                                ),
                              ),
                            );
                          },
                          onDelete: widget.userId != null
                              ? () => _deleteApartment(apartment.id, context)
                              : null,
                          onEdit: widget.userId != null
                              ? () => _editApartment(apartment, context)
                              : null,
                        );
                      },
                    ),
          ),
        ],
      ),

      floatingActionButton:
          widget.userId != null
              ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DepartmentFormScreen(
                            idUser: widget.userId!,
                            idCity: widget.cityId,
                          ),
                    ),
                  );
                },
              )
              : null,

    );
  }
}