import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/rentals_screen.dart';
import 'houses/houses_screen.dart';
import 'terrenos_screen.dart';
import 'apartaments/apartaments_screen.dart';
import 'rentalsscreens.dart';

class Home2Screen extends StatefulWidget {
  final String tipo; // 'casas', 'terrenos', 'departamentos', 'alquileres'
  final int empresaId;
  final int cityId;

  const Home2Screen({
    Key? key,
    required this.tipo,
    required this.empresaId,
    required this.cityId,
  }) : super(key: key);

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  late String currentTipo;

  @override
  void initState() {
    super.initState();
    currentTipo = widget.tipo;
  }

  void onTipoChanged(String tipo) {
    setState(() {
      currentTipo = tipo;
    });
  }

  Widget getCurrentScreen() {
    switch (currentTipo) {
      case 'casas':
        return HousesScreen(
          empresaId: widget.empresaId,
          cityId: widget.cityId,
        );
      case 'terrenos':
        return LandsScreen(
          empresaId: widget.empresaId,
          cityId: widget.cityId,
        );
      case 'departamentos':
        return ApartmentsScreen(
          companyId: widget.empresaId,
          cityId: widget.cityId,
        );
      case 'alquileres':
        return RentalsScreen(
          companyId: widget.empresaId,
          cityId: widget.cityId,
        );
      default:
        return const Center(child: Text('Tipo no válido'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTipo[0].toUpperCase() + currentTipo.substring(1)),
      ),
      body: getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tipoToIndex(currentTipo),
        onTap: (index) {
          final tipoSeleccionado = _indexToTipo(index);
          if (tipoSeleccionado != currentTipo) {
            onTipoChanged(tipoSeleccionado);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Casas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: 'Terrenos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Departamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: 'Alquileres',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  int _tipoToIndex(String tipo) {
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

  String _indexToTipo(int index) {
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
