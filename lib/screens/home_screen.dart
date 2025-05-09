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
    });
  }

  void _cerrarSesion() {
    setState(() {
      estaLogueado = false;
      idUsuario = null;
      futureProperties = apiService.fetchProperties();
    });
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
                    icon: const Icon(Icons.person_2_rounded, color: Colors.black),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sesión finalizada'),
                              content: const Text('Has cerrado sesión exitosamente.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'perfil',
                        child: Text('Ver perfil'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'cerrar',
                        child: Text('Cerrar sesión'),
                      ),
                    ],
                  )
                : TextButton(
                    onPressed: () async {
                      final nuevoUsuarioId = await Navigator.push<int?>(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );

                      if (nuevoUsuarioId != null) {
                        setState(() {
                          idUsuario = nuevoUsuarioId;
                          estaLogueado = true;
                          futureProperties = apiService.fetchPropertiesByUserId(idUsuario!);
                        });
                      }
                    },
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
            return screenBuilders[selectedCategoryIndex](snapshot.data!);
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
