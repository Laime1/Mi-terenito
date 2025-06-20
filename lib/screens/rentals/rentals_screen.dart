import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/rentals/rental_detail_screen.dart';
import 'package:mi_terrenito/screens/rentals/rental_form_screen.dart';
import 'package:mi_terrenito/widgets/rental_card.dart';
import 'package:mi_terrenito/services/api_service.dart';

import '../../models/rental.dart';

class RentalsScreen extends StatefulWidget {
   final int companyId;
   final int cityId;
   final int? userId;

  const RentalsScreen({
    super.key,
     required this.companyId,
     required this.cityId,
    required this.userId
  });

  @override
  State<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends State<RentalsScreen> {

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
      final List<Rental>  rentals;

      widget.userId != null
          ?rentals = await ApiService.fetchAlquileresByUsuario(widget.userId!)
          :rentals = await ApiService.getRentalsByCompanyAndCity(companyId: widget.companyId,cityId: widget.cityId);

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
                final Rental rental = filteredRentals[index];
                return RentalCard(rental: rental,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentalDetailScreen(
                          rental: filteredRentals[index],
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
      floatingActionButton: widget.userId != null
      ? FloatingActionButton(
        child: const Icon(Icons.add_box),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => RentalFormScreen(idUser: widget.userId!, idCity: 4,),
            ),
            );
          },
      )
      : null,
    );
  }
}