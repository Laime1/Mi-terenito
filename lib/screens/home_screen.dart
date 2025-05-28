import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/login.screen.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property/property.dart';
import '../services/api_service.dart';
import 'houses.screens.dart';
import 'lands.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? idRol;
  String nombreUsuario = 'Usuario';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    idUsuario = prefs.getInt('id_usuario') ?? widget.idUsuario;
    idRol = prefs.getInt('id_rol');
    String? nombreGuardado = prefs.getString('nombre_usuario');

    if (idUsuario != null) {
      estaLogueado = true;

      if (nombreGuardado == null) {
        final userData = await apiService.getUserById(idUsuario!);
        nombreUsuario = userData['nombre_usuario'] ?? 'Usuario';
        await prefs.setString('nombre_usuario', nombreUsuario);
      } else {
        nombreUsuario = nombreGuardado;
      }

      futureProperties = apiService.fetchPropertiesByUserId(idUsuario!);
    } else {
      estaLogueado = false;
      futureProperties = apiService.fetchProperties();
    }

    setState(() {});
  }

  void _onItemTapped(int index) {
    if (idRol == 2 && (index == 1 || index == 2)) {
      _mostrarDialogoPremium();
      return;
    }
    setState(() {
      selectedCategoryIndex = index;
      futureProperties = estaLogueado
          ? apiService.fetchPropertiesByUserId(idUsuario!)
          : apiService.fetchProperties();
    });
  }

  void _mostrarDialogoPremium() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Acceso restringido"),
          content: const Text("Debes convertirte en usuario premium para acceder a esta sección."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_usuario');
    await prefs.remove('id_rol');
    await prefs.remove('nombre_usuario');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _iniciarSesion() async {
    final nuevoUsuarioId = await Navigator.push<int?>(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    if (nuevoUsuarioId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id_usuario', nuevoUsuarioId);
      final userData = await apiService.getUserById(nuevoUsuarioId);
      final idRolUsuario = userData['id_rol'];
      final nombre = userData['nombre_usuario'] ?? 'Usuario';
      await prefs.setInt('id_rol', idRolUsuario);
      await prefs.setString('nombre_usuario', nombre);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
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
        backgroundColor: const Color(0xFF1E3D3D),
        elevation: 0.5,
        title: Row(
          children: [
            Image.asset(
              'assets/home_terreno.png',
              height: 35,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 8),
            const Text(
              'CLICK HOUSE',
              style: TextStyle(
                color: Color.fromARGB(255, 243, 245, 246),
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0, left: 8.0),
            child: estaLogueado
                ? PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_2_rounded, color: Colors.black, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            nombreUsuario,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'InknutAntiqua',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'perfil',
                        child: Row(
                          children: const [
                            Icon(Icons.person, size: 18, color: Colors.black54),
                            SizedBox(width: 6),
                            Text('Ver perfil', style: TextStyle(fontSize: 10, fontFamily: 'InknutAntiqua')),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'cerrar',
                        child: Row(
                          children: const [
                            Icon(Icons.logout, size: 18, color: Colors.redAccent),
                            SizedBox(width: 6),
                            Text('Cerrar sesión', style: TextStyle(fontSize: 10, color: Colors.redAccent, fontFamily: 'InknutAntiqua')),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (String result) {
                      if (result == 'perfil') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen(idUsuario: idUsuario!)),
                        );
                      } else if (result == 'cerrar') {
                        _cerrarSesion();
                      }
                    },
                  )
                : TextButton(
                    onPressed: _iniciarSesion,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InknutAntiqua',
                        fontSize: 12,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedCategoryIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFF1E3D3D),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.landscape_sharp),
            label: 'Terrenos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_work_sharp,
              color: idRol == 2 ? Colors.grey : null,
            ),
            label: 'Alquileres',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_sharp,
              color: idRol == 2 ? Colors.grey : null,
            ),
            label: 'Casas',
          ),
        ],
      ),
    );
  }
}