import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCity = 'COCHABAMBA';
  List<String> cities = ['COCHABAMBA', 'LA PAZ', 'SANTA CRUZ', 'ORURO', 'POTOSÍ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '9:30',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Mi Terrenito',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navegar a favoritos
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButton<String>(
              value: selectedCity,
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              items: cities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                _buildMenuItem('Casas', Icons.home),
                _buildMenuItem('Terrenos', Icons.landscape),
                _buildMenuItem('Departamentos', Icons.apartment),
                _buildMenuItem('Alquileres', Icons.home_work),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {
          // Acción al hacer clic
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}