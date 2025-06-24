import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/land.dart';
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

  void filterTerrenos(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      searchText = query;
      filteredTerrenos = terrenos.where((terreno) {
        final title = terreno.title.toLowerCase();
        final description = terreno.description.toLowerCase();
        return title.contains(lowerQuery) || description.contains(lowerQuery);
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
        SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar terrenos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterTerrenos,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
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
                                  builder: (_) => DetailLandScrenn(terreno: terreno),
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
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: widget.usuarioId != null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormLandScreen(
                      idUsuario: widget.usuarioId!,
                      idCiudad: widget.cityId,
                    ),
                  ),
                ).then((value) {
                  if (value == true) loadAllData();
                });
              },
            )
          : null,
    );
  }
}
