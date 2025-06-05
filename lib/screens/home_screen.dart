import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/app_colors.dart';
import 'package:mi_terrenito/screens/login.screen.dart';
import 'package:mi_terrenito/screens/profile_secreen.dart';
import 'package:mi_terrenito/screens/rentals_screens.dart';
import '../models/property/property.dart';
import '../services/api_service.dart';
import 'houses.screens.dart';
import 'lands.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'departments_screen.dart';


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
    setState(() {
      selectedCategoryIndex = index;
      futureProperties = estaLogueado
          ? apiService.fetchPropertiesByUserId(idUsuario!)
          : apiService.fetchProperties();
    });
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
      (props) => DepartmentsScreen(properties: props, idUsuario: idUsuario),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
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
                color: AppColors.gold,
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
                              color: AppColors.gold,
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
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: FutureBuilder<List<Property>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final propiedadesFiltradas =
                snapshot.data!.where((p) => p.status != 0).toList();
            return screenBuilders[selectedCategoryIndex](propiedadesFiltradas);
          } else if (snapshot.hasError) {
            Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                futureProperties = estaLogueado
                    ? apiService.fetchPropertiesByUserId(idUsuario!)
                    : apiService.fetchProperties();
              });
            });

            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error al obtener propiedades. Por favor, espere...',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedCategoryIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: AppColors.appBarText,
        backgroundColor: AppColors.appBarBackground,
        items: [
          BottomNavigationBarItem(
            icon: _buildRoundedIcon(
              icon: Icons.landscape_sharp,
              isActive: selectedCategoryIndex == 0,
            ),
            label: 'Terrenos',
          ),
          BottomNavigationBarItem(
            icon: _buildRoundedIcon(
              icon: Icons.home_work_sharp,
              isActive: selectedCategoryIndex == 1,
            ),
            label: 'Alquileres',
          ),
          BottomNavigationBarItem(
            icon: _buildRoundedIcon(
              icon: Icons.home_sharp,
              isActive: selectedCategoryIndex == 2,
            ),
            label: 'Casas',
          ),
          BottomNavigationBarItem(
      icon: _buildRoundedIcon(
        icon: Icons.apartment,
        isActive: selectedCategoryIndex == 3,
      ),
      label: 'Departamentos',
    ),
        ],
      ),
    );
  }
}

Widget _buildRoundedIcon({
  required IconData icon,
  required bool isActive,
}) {
  final color = isActive ? const Color(0xFFFFD700) : Colors.grey[400];

  return Container(
    padding: const EdgeInsets.all(6),
    decoration: isActive
        ? BoxDecoration(
            color: AppColors.gold.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold, width: 1.5),
          )
        : null,
    child: Icon(icon, color: color),
  );
}
