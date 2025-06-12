import 'package:flutter/material.dart';
import 'package:mi_terrenito/widgets/rental1_card.dart';
import 'package:mi_terrenito/services/api_services.dart';

import '../models/Rent.dart';

class RentalsScreen extends StatefulWidget {
  // final int companyId;
  // final int cityId;

  const RentalsScreen({
    super.key,
    // required this.companyId,
    // required this.cityId,
  });

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {
  static const int companyId = 1;
  static const int cityId = 1;
  late TextEditingController searchController;
  List<Rental> filteredRentals = [];
  List<Rental> allRentals = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadRentals();
    searchController.addListener(_filterRentals);
  }

  Future<void> _loadRentals() async {
    try {
      final rentals = await ApiService.getRentalsByCompanyAndCity(
        companyId: companyId,
        cityId: cityId,
      );

      setState(() {
        allRentals = rentals;
        filteredRentals = rentals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _filterRentals() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRentals = allRentals.where((rental) {
        return rental.title.toLowerCase().contains(query) ||
            rental.description.toLowerCase().contains(query) ||
            rental.monthlyPrice.toString().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALQUILERES'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar alquileres...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : filteredRentals.isEmpty
                ? const Center(child: Text('No hay alquileres disponibles'))
                : ListView.builder(
              itemCount: filteredRentals.length,
              itemBuilder: (context, index) {
                return RentalCard(rental: filteredRentals[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}