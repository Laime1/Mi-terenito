import 'package:flutter/material.dart';
import 'package:mi_terrenito/services/api_service.dart';

import '../models/apartament.dart';
import '../widgets/card_apartament.dart';

class ApartmentsScreen extends StatefulWidget {
  final int companyId;
  final int cityId;

  const ApartmentsScreen({
    super.key,
    required this.companyId,
    required this.cityId,
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
      final apartments = await ApiService.getApartmentsByCompanyAndCity(
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
      filteredApartments = allApartments.where((apt) {
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : filteredApartments.isEmpty
                ? const Center(
              child: Text(
                'No se encontraron departamentos',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredApartments.length,
              itemBuilder: (context, index) {
                return ApartmentCard(
                  apartment: filteredApartments[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}