import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_detail_screen.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_form_screen.dart';
import 'package:mi_terrenito/widgets/loader_overlay.dart';
import 'package:mi_terrenito/services/api_service.dart';
import '../../models/apartment.dart';
import '../../widgets/card_apartament.dart';
import '../../widgets/custom_search_bar.dart';

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

  void filterApartments(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredApartments = allApartments.where((apt) {
        return apt.title.toLowerCase().contains(lowerQuery) ||
            apt.description.toLowerCase().contains(lowerQuery) ||
            apt.price.toString().contains(lowerQuery);
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
          idCity: widget.cityId, 
          apartment: apartment,
        ),
      ),
    ).then((_) => _loadApartments()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(
            onChanged: filterApartments,
            hintText: 'Buscar departamento...',
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
              ? FloatingActionButton.small(
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
                    ).then((_) => _loadApartments()); 
                },
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}