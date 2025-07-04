import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/rentals/rental_detail_screen.dart';
import 'package:mi_terrenito/screens/rentals/rental_form_screen.dart';
import 'package:mi_terrenito/widgets/loader_overlay.dart';
import 'package:mi_terrenito/widgets/rental_card.dart';
import 'package:mi_terrenito/services/api_service.dart';

import '../../models/rental.dart';
import '../../widgets/custom_search_bar.dart';

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

  void filterRentals(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredRentals = allRentals.where((apt) {
        return apt.description.toLowerCase().contains(lowerQuery) ||
            apt.description.toLowerCase().contains(lowerQuery) ||
            apt.monthlyPrice.toString().contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _deleteRental(int id, BuildContext context) async {
    try {
      final success = await ApiService.deleteRental(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Departamento desactivado correctamente')),
        );
        _loadRentals(); // Recargar la lista
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _editRental(Rental rental, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentalFormScreen(
          idUser: widget.userId!,
          idCity: widget.cityId,
          rental: rental,
           // Asegúrate de que tu form screen acepte esto
        ),
      ),
    ).then((_) => _loadRentals()); // Recargar después de editar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(
            onChanged: filterRentals,
            hintText: 'Buscar departamento...',
          ),
          Expanded(
            child: isLoading
                ? const HouseLoader()
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : filteredRentals.isEmpty
                ? Center(child: Text('No hay alquileres disponibles'))
                : ListView.builder(
              itemCount: filteredRentals.length,
              itemBuilder: (context, index) {
                final Rental rental = filteredRentals[index];
                return RentalCard(
                  rental: rental,
                    enableSwipeActions: widget.userId != null,
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
                  onDelete: widget.userId != null
                     ? () => _deleteRental(rental.id, context)
                     :null,
                  onEdit: widget.userId != null
                    ? () => _editRental(rental, context )
                    : null
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.userId != null
      ? FloatingActionButton.small(
        child: const Icon(Icons.add),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => RentalFormScreen(idUser: widget.userId!, idCity: 4,),
            ),
            ).then((_) => _loadRentals()); 
          },
      )
      : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,

    );
  }
}