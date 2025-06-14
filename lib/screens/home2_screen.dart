import 'package:flutter/material.dart';
import 'casas_screen.dart';
import 'terrenos_screen.dart';
import 'departaments_screen.dart';
import 'rentals_screens.dart';
import 'home_screen.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import '../models/app_colors.dart';

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
    switch (currentTipo) {
      case 'home':
        return HomeScreen(
          selectedCity: widget.selectedCityName,
          selectedEmpresaName: widget.selectedEmpresaName,
          selectedEmpresaId: widget.empresaId,
          hasCasas: hasCasas,
          hasTerrenos: hasTerrenos,
          hasDepartamentos: hasDepartamentos,
          hasAlquileres: hasAlquileres,
        );
      case 'casas':
        return CasasScreen(empresaId: widget.empresaId, cityId: widget.cityId);
      case 'terrenos':
        return TerrenosScreen(empresaId: widget.empresaId, cityId: widget.cityId);
      case 'departamentos':
        return DepartmentsScreen(empresaId: widget.empresaId, cityId: widget.cityId);
      case 'alquileres':
        return RentalsScreen(empresaId: widget.empresaId, cityId: widget.cityId);
      default:
        return const Center(child: Text('Tipo no válido'));
    }
  }

  int _tipoToIndex(String tipo) {
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
        return 1;
    }
  }

  String _indexToTipo(int index) {
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
        return 'casas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTipo[0].toUpperCase() + currentTipo.substring(1)),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
        tabs: [
          TabData(icon: Icons.home, title: 'Inicio'),
          TabData(icon: Icons.house_rounded, title: 'Casas'),
          TabData(icon: Icons.park_rounded, title: 'Terrenos'),
          TabData(icon: Icons.apartment_rounded, title: 'Departamentos'),
          TabData(icon: Icons.real_estate_agent_rounded, title: 'Alquileres'),
        ],
        onTabChangedListener: (position) {
          String nuevoTipo = _indexToTipo(position);

          if (nuevoTipo == 'home') {
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
              (Route<dynamic> route) => false,
            );
            return;
          }

          if (_isTabEnabled(position)) {
            setState(() {
              currentTipo = nuevoTipo;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No hay propiedades disponibles para esta categoría'),
              ),
            );
          }
        },
      ),
    );
  }

  bool _isTabEnabled(int index) {
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
  }
}
