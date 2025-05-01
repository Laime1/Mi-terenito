import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property/property.dart';
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
  late Future<List<Property>> futureProperties;
  final ApiService apiService = ApiService();



  // Datos de ejemplo (podrías mover esto a un servicio/repositorio)

  //late final List<Widget> _bottomNavScreens;
  late  final List<Widget> _categoryScreens = [
    FutureBuilder<List<Property>>(
      future: ApiService().fetchProperties(),
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


  @override
  void initState(){
    super.initState();
    futureProperties = apiService.fetchProperties();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
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
            child: IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                icon: Icon(Icons.person_2_rounded),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _categoryScreens[selectedCategoryIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),

    );
    
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedCategoryIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.landscape_sharp, ),
          label: 'Terrenos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work_sharp, ),
          label: 'Alquileres',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
          label: 'Casas'
        )
      ],
    );
  }
}

