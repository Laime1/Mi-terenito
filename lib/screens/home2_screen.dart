import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/apartaments/apartaments_screen.dart';
import 'package:mi_terrenito/screens/rentals/rentals_screen.dart';
import 'houses/houses_screen.dart';
import 'lands/terrenos_screen.dart';
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

  @override
  void initState() {
    super.initState();
    currentTipo = widget.tipo;

    hasCasas = widget.hasCasas;
    hasTerrenos = widget.hasTerrenos;
    hasDepartamentos = widget.hasDepartamentos;
    hasAlquileres = widget.hasAlquileres;
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
        return CasasScreen(empresaId: widget.empresaId, cityId: widget.cityId,usuarioId: widget.usuarioId,);
      case 'terrenos':
        return TerrenosScreen(empresaId: widget.empresaId, cityId: widget.cityId,usuarioId:widget.usuarioId);
      case 'departamentos':
        return ApartmentsScreen(companyId: widget.empresaId, cityId: widget.cityId,userId:widget.usuarioId);
      case 'alquileres':
        return RentalsScreen(companyId: widget.empresaId, cityId: widget.cityId,userId:widget.usuarioId);
      default:
        return const Center(child: Text('Tipo no válido'));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentTipo[0].toUpperCase() + currentTipo.substring(1),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          if (widget.isLoggedIn)
            PopupMenuButton<String>(
              icon: const Icon(Icons.person, color: Colors.black54, size: 18),
              onSelected: (value) {
                if (value == 'verperfil') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ver perfil seleccionado')),
                  );
                } else if (value == 'cerrarsesion') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'verperfil',
                  child: Text('Ver perfil'),
                ),
                PopupMenuItem(
                  value: 'cerrarsesion',
                  child: Text('Cerrar sesión'),
                ),
              ],
            ),
        ],
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: CircleBottomNavigation(
        initialSelection: _tipoToIndex(currentTipo),
        barHeight: 50,
        circleSize: 40,
        barBackgroundColor: Colors.white,
        activeIconColor: Colors.white,
        inactiveIconColor: Colors.grey,
        circleColor: Colors.blueAccent,
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
              const SnackBar(
                content: Text('No hay propiedades disponibles para esta categoría'),
              ),
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
