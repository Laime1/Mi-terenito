import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/land.dart';
import 'package:mi_terrenito/widgets/loader_overlay.dart';
import '../../widgets/custom_search_bar.dart';
import '/widgets/card_lands.dart';
import 'detail_land_screen.dart';
import '../home2_screen.dart';
import 'form_land_screen.dart';

class LandsScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;
  final int? usuarioId;

  const LandsScreen({
    Key? key,
    required this.empresaId,
    required this.cityId,
    this.usuarioId,
  }) : super(key: key);

  @override
  State<LandsScreen> createState() => _LandsScreenState();
}

class _LandsScreenState extends State<LandsScreen> {
  bool isLoading = true;
  List<Land> terrenos = [];
  List<Land> filteredTerrenos = [];
  String searchText = '';

  bool hasCasas = false;
  bool hasTerrenos = false;
  bool hasDepartamentos = false;
  bool hasAlquileres = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    setState(() => isLoading = true);
    try {
      final loadedTerrenosJson = widget.usuarioId != null
          ? await apiService.fetchTerrenosByUsuario(widget.usuarioId!)
          : await apiService.fetchTerrenosByEmpresaAndCiudad(widget.empresaId, widget.cityId);

      final loadedCasas = await apiService.fetchCasasByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedDepartamentos = await apiService.fetchDepartamentosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedAlquileres = await apiService.fetchAlquileresByEmpresaAndCiudad(widget.empresaId, widget.cityId);

      final loadedTerrenos = loadedTerrenosJson.map<Land>((json) => Land.fromJson(json)).toList();

      setState(() {
        terrenos = loadedTerrenos;
        filteredTerrenos = loadedTerrenos;
        hasTerrenos = loadedTerrenos.isNotEmpty;
        hasCasas = loadedCasas.isNotEmpty;
        hasDepartamentos = loadedDepartamentos.isNotEmpty;
        hasAlquileres = loadedAlquileres.isNotEmpty;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void filterLands(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      searchText = query;
      filteredTerrenos =
          terrenos.where((casa) {
            final title = casa.title.toLowerCase();
            final cityName = casa.city?.name.toLowerCase() ?? '';
            return title.contains(lowerQuery) || cityName.contains(lowerQuery);
          }).toList();
    });
  }

  void navigateTo(String tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Home2Screen(
          tipo: tipo,
          empresaId: widget.empresaId,
          cityId: widget.cityId,
          hasCasas: hasCasas,
          hasTerrenos: hasTerrenos,
          hasDepartamentos: hasDepartamentos,
          hasAlquileres: hasAlquileres,
        ),
      ),
    );
  }

  Future<void> _deleteTerreno(int id, BuildContext context) async {
    try {
      final success = await ApiService.eliminarTerreno(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terreno eliminado correctamente')),
        );
        await loadAllData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _editLand(Land land, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LandFormScreen(
              idUser: widget.usuarioId!,
              idCity: widget.cityId,
              land: land,
               idEmpresa: widget.empresaId,
            ),
      ),
    ).then((_) => loadAllData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomSearchBar(
            onChanged: filterLands,
            hintText: 'Buscar departamento...',
          ),
          Expanded(
            child: isLoading
                ? const HouseLoader()
                : filteredTerrenos.isEmpty
                    ? Center(
                        child: Text(
                          widget.usuarioId != null
                              ? 'Sin terrenos publicados.'
                              : 'No hay terrenos disponibles.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTerrenos.length,
                        itemBuilder: (context, index) {
                          final terreno = filteredTerrenos[index];
                          return LandCard(
                            land: terreno,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailLandScreen(
                                    terreno: terreno,
                                    usuarioId: widget.usuarioId,
                                  ),
                                ),
                              );
                              if (result == true) {
                                await loadAllData();
                              }
                            },
                            enableSwipeActions: widget.usuarioId != null,
                            onDelete: widget.usuarioId != null
                                ? () => _deleteTerreno(terreno.id, context)
                                : null,
                            onEdit: widget.usuarioId != null
                                 ? () => _editLand(terreno, context)
                                 : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: widget.usuarioId != null
          ? FloatingActionButton.small(
            child:  Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LandFormScreen(
                      idUser: widget.usuarioId!,
                      idCity: widget.cityId,
                      idEmpresa: widget.empresaId,
                    ),
                  ),
                );
              },
              
              tooltip: 'Agregar Terreno',
            )
          : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
