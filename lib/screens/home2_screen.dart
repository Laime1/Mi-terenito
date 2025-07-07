// ...importaciones sin cambios
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_terrenito/models/app_fonts.dart';
import 'package:mi_terrenito/screens/apartaments/apartaments_screen.dart';
import 'package:mi_terrenito/screens/rentals/rentals_screen.dart';
import '../services/theme_provider.dart';
import 'houses/houses_screen.dart';
import 'lands/lands_screen.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import '../models/app_colors.dart';
import 'home_screen.dart';

class Home2Screen extends StatefulWidget {
  final String tipo;
  final int empresaId;
  final int cityId;
  final String selectedCityName;
  final String selectedEmpresaName;
  final bool hasCasas;
  final bool hasTerrenos;
  final bool hasDepartamentos;
  final bool hasAlquileres;
  final bool isLoggedIn;
  final int? usuarioId;
  final String? usuarioName;

  const Home2Screen({
    Key? key,
    required this.tipo,
    required this.empresaId,
    required this.cityId,
    this.selectedCityName = '',
    this.selectedEmpresaName = '',
    this.hasCasas = false,
    this.hasTerrenos = false,
    this.hasDepartamentos = false,
    this.hasAlquileres = false,
    this.isLoggedIn = false,
    this.usuarioId,
    this.usuarioName,
  }) : super(key: key);

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  late String currentTipo;
  late bool hasCasas;
  late bool hasTerrenos;
  late bool hasDepartamentos;
  late bool hasAlquileres;
  String? usuarioName;

  @override
  void initState() {
    super.initState();
    currentTipo = widget.tipo;
    hasCasas = widget.hasCasas;
    hasTerrenos = widget.hasTerrenos;
    hasDepartamentos = widget.hasDepartamentos;
    hasAlquileres = widget.hasAlquileres;

    if (widget.usuarioName != null && widget.usuarioName!.isNotEmpty) {
      usuarioName = widget.usuarioName;
    } else {
      _loadUserName();
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('usuarioNameKey');
    if (name != null && mounted) {
      setState(() {
        usuarioName = name;
      });
    }
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Widget getCurrentScreen() {
    if (!widget.isLoggedIn && currentTipo == 'home') {
      return HomeScreen(
        selectedCity: widget.selectedCityName,
        selectedEmpresaName: widget.selectedEmpresaName,
        selectedEmpresaId: widget.empresaId,
        hasCasas: hasCasas,
        hasTerrenos: hasTerrenos,
        hasDepartamentos: hasDepartamentos,
        hasAlquileres: hasAlquileres,
      );
    }

    switch (currentTipo) {
      case 'casas':
        return CasasScreen(empresaId: widget.empresaId, cityId: widget.cityId, usuarioId: widget.usuarioId);
      case 'terrenos':
        return LandsScreen(empresaId: widget.empresaId, cityId: widget.cityId, usuarioId: widget.usuarioId);
      case 'departamentos':
        return ApartmentsScreen(companyId: widget.empresaId, cityId: widget.cityId, userId: widget.usuarioId);
      case 'alquileres':
        return RentalsScreen(companyId: widget.empresaId, cityId: widget.cityId, userId: widget.usuarioId);
      default:
        return const Center(child: Text('Tipo no válido'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.isLoggedIn && usuarioName != null && usuarioName!.isNotEmpty)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 16, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    usuarioName!,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            const Spacer(),
            Text(
              currentTipo[0].toUpperCase() + currentTipo.substring(1),
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(flex: 2),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          if (widget.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              onPressed: () {
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Está seguro que quiere cerrar sesión?'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        cerrarSesion();
                      },
                      child: const Text('Sí'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );

              },
            ),
        ],
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: CircleBottomNavigation(
        initialSelection: _tipoToIndex(currentTipo),
        barHeight: 50,
        circleSize: 40,
        barBackgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        activeIconColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveIconColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        circleColor: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
        tabs: widget.isLoggedIn
            ? [
                TabData(icon: Icons.house_rounded, title: 'Casas'),
                TabData(icon: Icons.park_rounded, title: 'Terrenos'),
                TabData(icon: Icons.apartment_rounded, title: 'Departamentos'),
                TabData(icon: Icons.real_estate_agent_rounded, title: 'Alquileres'),
              ]
            : [
                TabData(icon: Icons.home, title: 'Inicio'),
                TabData(icon: Icons.house_rounded, title: 'Casas'),
                TabData(icon: Icons.park_rounded, title: 'Terrenos'),
                TabData(icon: Icons.apartment_rounded, title: 'Departamentos'),
                TabData(icon: Icons.real_estate_agent_rounded, title: 'Alquileres'),
              ],
        onTabChangedListener: (position) {
          String nuevoTipo = _indexToTipo(position);

          if (!_isTabEnabled(position)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay propiedades disponibles para esta categoría')),
            );
            return;
          }

          if (!widget.isLoggedIn && nuevoTipo == 'home') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  selectedCity: widget.selectedCityName,
                  selectedEmpresaName: widget.selectedEmpresaName,
                  selectedEmpresaId: widget.empresaId,
                  hasCasas: hasCasas,
                  hasTerrenos: hasTerrenos,
                  hasDepartamentos: hasDepartamentos,
                  hasAlquileres: hasAlquileres,
                ),
              ),
              (route) => false,
            );
            return;
          }

          setState(() {
            currentTipo = nuevoTipo;
          });
        },
      ),
    );
  }

  int _tipoToIndex(String tipo) {
    if (!widget.isLoggedIn) {
      switch (tipo) {
        case 'home':
          return 0;
        case 'casas':
          return 1;
        case 'terrenos':
          return 2;
        case 'departamentos':
          return 3;
        case 'alquileres':
          return 4;
        default:
          return 0;
      }
    } else {
      switch (tipo) {
        case 'casas':
          return 0;
        case 'terrenos':
          return 1;
        case 'departamentos':
          return 2;
        case 'alquileres':
          return 3;
        default:
          return 0;
      }
    }
  }

  String _indexToTipo(int index) {
    if (!widget.isLoggedIn) {
      switch (index) {
        case 0:
          return 'home';
        case 1:
          return 'casas';
        case 2:
          return 'terrenos';
        case 3:
          return 'departamentos';
        case 4:
          return 'alquileres';
        default:
          return 'home';
      }
    } else {
      switch (index) {
        case 0:
          return 'casas';
        case 1:
          return 'terrenos';
        case 2:
          return 'departamentos';
        case 3:
          return 'alquileres';
        default:
          return 'casas';
      }
    }
  }

  bool _isTabEnabled(int index) {
    if (!widget.isLoggedIn) {
      switch (index) {
        case 0:
          return true;
        case 1:
          return hasCasas;
        case 2:
          return hasTerrenos;
        case 3:
          return hasDepartamentos;
        case 4:
          return hasAlquileres;
        default:
          return false;
      }
    } else {
      switch (index) {
        case 0:
          return hasCasas;
        case 1:
          return hasTerrenos;
        case 2:
          return hasDepartamentos;
        case 3:
          return hasAlquileres;
        default:
          return false;
      }
    }
  }
}
