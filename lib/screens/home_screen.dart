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

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  int? idRol;
  Future<void> _loadUserId() async {
  final prefs = await SharedPreferences.getInstance();
  idUsuario = prefs.getInt('id_usuario') ?? widget.idUsuario;
  idRol = prefs.getInt('id_rol'); // <-- Agrega esto
  print('idUsuario: $idUsuario, idRol: $idRol');

  setState(() {
    estaLogueado = idUsuario != null;
    futureProperties = estaLogueado
        ? apiService.fetchPropertiesByUserId(idUsuario!)
        : apiService.fetchProperties();
  });
}

void _onItemTapped(int index) {
  if (idRol == 2 && (index == 1 || index == 2)) { // Rol 2: vendedor
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
    setState(() {
      idUsuario = null;
      estaLogueado = false;
      selectedCategoryIndex = 0;
      futureProperties = apiService.fetchProperties();
    });
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
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

 void _iniciarSesion() async {
  final nuevoUsuarioId = await Navigator.push<int?>(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  
  if (nuevoUsuarioId != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_usuario', nuevoUsuarioId);

    // Obtener el id_rol desde la API y guardarlo
    final userData = await apiService.getUserById(nuevoUsuarioId);
    final idRol = userData['id_rol'];
    await prefs.setInt('id_rol', idRol);

    setState(() {
      idUsuario = nuevoUsuarioId;
      estaLogueado = true;
      selectedCategoryIndex = 0;
      futureProperties = apiService.fetchPropertiesByUserId(idUsuario!);
    });
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
                color: Colors.black,
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.bold,
                fontSize: 10,
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
                              style: TextStyle(fontSize: 10, fontFamily: 'InknutAntiqua'),
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
                              style: TextStyle(fontSize: 10, color: Colors.redAccent, fontFamily: 'InknutAntiqua'),
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
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InknutAntiqua',
                        fontSize: 10,
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
  backgroundColor: const Color.fromARGB(255, 210, 210, 219),
  items: [
    const BottomNavigationBarItem(
      icon: Icon(Icons.landscape_sharp),
      label: 'Terrenos',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_work_sharp,
        color: idUsuario == 2 ? Colors.grey : null,  // grisar icono si restringido
      ),
      label: 'Alquileres',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_sharp,
        color: idUsuario == 2 ? Colors.grey : null,
      ),
      label: 'Casas',
    ),
  ],
),

    );
  }
}
