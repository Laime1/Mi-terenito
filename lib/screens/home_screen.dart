import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property.dart';
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

  // Datos de ejemplo (podrías mover esto a un servicio/repositorio)
  final List<Property> properties = [
    Property(
      name: 'Archipielago Alalay(Cochabamba)',
      size: 400,
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYr-GmtrfZWSAxatZEkftLn6fXLD0QTqyCcQ&s',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s',
      ],
      description: 'Ubicado en pleno centro de la laguna alalay, con vista a la..',
      minPrice: 999,
      maxPrice: 1000,
      zone: 'Zona Sur',
      location: 'Cochabamba',
      mapLocation: 'https://www.google.com/maps/place/Plaza+Sucre/@-17.411946,-66.1632659,13z/data=!4m9!1m2!2m1!1zLA!3m5!1s0x93e373f8d705ee63:0x8b64d1ced4c8c13f!8m2!3d-17.3922658!4d-66.1480371!16s%2Fg%2F1tj3m4zb?hl=es-419&entry=ttu&g_ep=EgoyMDI1MDQyMi4wIKXMDSoASAFQAw%3D%3D',
    ),
  ];

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
    _categoryScreens = [
      LandScreen(properties: properties),
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
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildCategoryChips(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: _categoryScreens[selectedCategoryIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          icon: Icon(Icons.add, color: Colors.black),
          label: 'Agregar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: 'Perfil',
        ),
      ],
    );
  }
}

