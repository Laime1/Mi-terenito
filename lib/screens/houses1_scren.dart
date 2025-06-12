import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/house.dart';
import 'package:mi_terrenito/services/api_services.dart';

import '../models/app_colors.dart';
import '../widgets/house1_card.dart';

class HousesScreen extends StatefulWidget {
  // final int companyId;
  // final int cityId;

  const HousesScreen({
    super.key,
    // required this.companyId,
    // required this.cityId,
  });

  @override
  State<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
  static const int companyId = 1;
  static const int cityId = 1;

  late TextEditingController searchController;
  List<House> filteredHouses = [];
  List<House> allHouses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadHouses();
    searchController.addListener(_filterHouses);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHouses() async {
    try {
      final houses = await ApiService.getHousesByCompanyAndCity(
        companyId: companyId,
        cityId: cityId,
      );

      setState(() {
        allHouses = houses;
        filteredHouses = houses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _filterHouses() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredHouses = allHouses.where((house) {
        return house.title.toLowerCase().contains(query) ||
            house.description.toLowerCase().contains(query) ||
            house.price.toString().contains(query);
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
            'CASAS DISPONIBLES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.gold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar casas...',
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
                ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.black),
              ),
            )
                : filteredHouses.isEmpty
                ? const Center(
              child: Text(
                'No hay casas disponibles con los filtros actuales',
                style: TextStyle(color: Colors.black),
              ),
            )
                : ListView.builder(
              itemCount: filteredHouses.length,
              itemBuilder: (context, index) {
                return HouseCard(house: filteredHouses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}