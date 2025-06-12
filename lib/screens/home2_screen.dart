import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Home2Screen extends StatefulWidget {
  final String tipo; // casas, terrenos, departamentos, alquileres
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
  final ApiService apiService = ApiService();

  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentTipo = widget.tipo;
    loadItems();
  }

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<dynamic> fetchedItems = [];
     
      setState(() {
        items = fetchedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        items = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando $currentTipo')),
      );
    }
  }

  void onTipoChanged(String tipo) {
    setState(() {
      currentTipo = tipo;
    });
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTipo[0].toUpperCase() + currentTipo.substring(1)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(child: Text('No hay $currentTipo disponibles.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(item['nombre'] ?? 'Sin nombre'),
                        subtitle: Text(item['descripcion'] ?? ''),
                        onTap: () {
                          // Aquí puedes navegar a detalle del item según tipo
                          // Por ejemplo, si es terreno:
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleTerrenoScreen(item: item)));
                        },
                      ),
                    );
                  },
                ),
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
