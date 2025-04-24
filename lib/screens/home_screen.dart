import 'package:flutter/material.dart';

import '../models/property.dart';
import 'lands.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // Categoría seleccionada
  int bottomNavIndex = 0; // Índice barra inferior
  List<String> categories = ['Terrenos', 'Alquileres', 'Casas'];
  String searchText = ''; // Texto del buscador

  final List<Property> properties = [
    Property(
        name: 'Archipielago Alalay(Cochabamba)',
        size: 400,
        images: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYr-GmtrfZWSAxatZEkftLn6fXLD0QTqyCcQ&s', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s'],
        description: 'Ubicado en pleno centro de la laguna alalay, con vista a la..',
        minPrice: 999,
        maxPrice: 1000,
        zone: 'Zona Sur',
        location: 'Cochabamba',
        mapLocation: 'https://www.google.com/maps/place/Plaza+Sucre/@-17.411946,-66.1632659,13z/data=!4m9!1m2!2m1!1zLA!3m5!1s0x93e373f8d705ee63:0x8b64d1ced4c8c13f!8m2!3d-17.3922658!4d-66.1480371!16s%2Fg%2F1tj3m4zb?hl=es-419&entry=ttu&g_ep=EgoyMDI1MDQyMi4wIKXMDSoASAFQAw%3D%3D'
    ),
    Property(
        name: 'Archipielago Alalay(Cochabamba)',
        size: 400,
        images: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s'],
        description: '''Ubicado en pleno centro de la laguna alalay, con vista a la...''',
        minPrice: 999,
        maxPrice: 1000,
        zone: 'Zona Sur',
        location: 'Cochabamba',
        mapLocation: 'https://www.google.com/maps/place/Plaza+Sucre/@-17.411946,-66.1632659,13z/data=!4m9!1m2!2m1!1zLA!3m5!1s0x93e373f8d705ee63:0x8b64d1ced4c8c13f!8m2!3d-17.3922658!4d-66.1480371!16s%2Fg%2F1tj3m4zb?hl=es-419&entry=ttu&g_ep=EgoyMDI1MDQyMi4wIKXMDSoASAFQAw%3D%3D'
    ),
  ];

  void onBottomNavTapped(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: const [
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(categories.length, (index) {
                  final isSelected = index == selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.black : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            const Icon(Icons.check, size: 16),
                            const SizedBox(width: 6),
                          ],
                          Text(categories[index]),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: selectedIndex == 0
                ? LandScreen(properties: properties)
                : Center(
              child: Text(
                'Mostrando: ${categories[selectedIndex]}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        onTap: onBottomNavTapped,
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
      ),
    );
  }
}
