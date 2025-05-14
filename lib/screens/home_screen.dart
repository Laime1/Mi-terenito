import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/login.screen.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property/property.dart';
import '../services/api_service.dart';
import 'houses.screens.dart';
import 'lands.screen.dart';

class HomeScreen extends StatefulWidget {
  final int? idUsuario;

  const HomeScreen({super.key, this.idUsuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  late Future<List<Property>> futureProperties;
  final ApiService apiService = ApiService();
  bool estaLogueado = false;
  int? idUsuario;

  @override
  void initState() {
    super.initState();
    idUsuario = widget.idUsuario;
    estaLogueado = idUsuario != null;
    futureProperties = estaLogueado
        ? apiService.fetchPropertiesByUserId(idUsuario!)
        : apiService.fetchProperties();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedCategoryIndex = index;
      futureProperties = estaLogueado
          ? apiService.fetchPropertiesByUserId(idUsuario!)
          : apiService.fetchProperties();
    });
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sesión cerrada'),
          content: const Text('Sesion Finalizada.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _iniciarSesion() async {
    final nuevoUsuarioId = await Navigator.push<int?>(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (nuevoUsuarioId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(idUsuario: nuevoUsuarioId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget Function(List<Property>)> screenBuilders = [
      (props) => LandsScreen(properties: props, idUsuario: idUsuario),
      (props) => RentalsScreen(properties: props, idUsuario: idUsuario),
      (props) => HousesScreen(properties: props, idUsuario: idUsuario),
    ];

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
            child: estaLogueado
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.person_2_rounded, color: Colors.black, size: 24),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'perfil',
                        height: 36,
                        child: Row(
                          children: const [
                            Icon(Icons.person, color: Colors.black54, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Ver perfil',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'cerrar',
                        height: 36,
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Colors.redAccent, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Cerrar sesión',
                              style: TextStyle(fontSize: 13, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (String result) {
                      if (result == 'perfil') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(idUsuario: idUsuario!),
                          ),
                        );
                      } else if (result == 'cerrar') {
                        _cerrarSesion();
                      }
                    },
                  )
                : TextButton(
                    onPressed: _iniciarSesion,
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Property>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final propiedadesFiltradas = snapshot.data!.where((p) => p.status != 0).toList();
            return screenBuilders[selectedCategoryIndex](propiedadesFiltradas);

          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
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
          icon: Icon(Icons.landscape_sharp),
          label: 'Terrenos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work_sharp),
          label: 'Alquileres',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_sharp),
          label: 'Casas',
        ),
      ],
    );
  }
}
