import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'houses.screens.dart';
import 'lands.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  int bottomNavIndex = 0;
  final List<String> categories = ['Terrenos', 'Alquileres', 'Casas'];
  String searchText = '';
  late Future<List<Property>> futureProperties;
  final ApiService apiService = ApiService();



  // Datos de ejemplo (podrías mover esto a un servicio/repositorio)

  //late final List<Widget> _bottomNavScreens;
  late  final List<Widget>  _categoryScreens;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FormScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    // _categoryScreens = [
    //   LandScreen(properties: properties),
    //   const RentalsScreen(),
    //   const HousesScreen(),
    // ];
    futureProperties = apiService.fetchProperties();
    _initializeScreens();
  }

  void _initializeScreens() {
    _categoryScreens = [
      FutureBuilder<List<Property>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LandScreen(properties: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      const RentalsScreen(),
      const HousesScreen(),
    ];
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        onChanged: (value) => setState(() => searchText = value),
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedCategoryIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedCategoryIndex = index),
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Row(
          children: [
            Icon(Icons.business, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Mi Terrenito',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.person),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: _buildSearchBar(),
        ),
      ),
      body: _categoryScreens[selectedCategoryIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
    
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: bottomNavIndex,
      onTap: _onBottomNavTapped,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bedroom_parent_sharp, color: Colors.black),
          label: 'Agregar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work_sharp, color: Colors.black),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.landscape_sharp),
          label: 'Terrenos'
        )
      ],
    );
  }
}

