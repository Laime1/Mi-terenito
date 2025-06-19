import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_detail_screen.dart';
import 'package:mi_terrenito/screens/apartaments/apartmet_form_screen.dart';
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
                    ? const Center(child: CircularProgressIndicator())
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
                        );
                      },
                    ),
          ),
        ],
      ),

      floatingActionButton:
          widget.userId != null
              ? FloatingActionButton(
                child: const Icon(Icons.add_box),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DepartmentFormScreen(
                            idUser: widget.userId!,
                            idCity: 4,
                          ),
                    ),
                  );
                },
              )
              : null,
    );
  }
}