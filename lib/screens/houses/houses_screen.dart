import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/house.dart';
import '../../widgets/card_houses.dart';
import 'details_house_screen.dart';
import '../home2_screen.dart';
import 'form_house_screen.dart';

class CasasScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;
  final int? usuarioId;

  const CasasScreen({
    Key? key,
    required this.empresaId,
    required this.cityId,
    this.usuarioId,
  }) : super(key: key);

  @override
  State<CasasScreen> createState() => _CasasScreenState();
}

class _CasasScreenState extends State<CasasScreen> {
  bool isLoading = true;
  List<House> casas = [];
  List<House> filteredCasas = [];
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
      List<dynamic> loadedCasasJson;
      if (widget.usuarioId != null) {
        loadedCasasJson = await apiService.fetchCasasByUsuario(widget.usuarioId!);
      } else {
        loadedCasasJson = await apiService.fetchCasasByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      }
      final loadedTerrenos = await apiService.fetchTerrenosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedDepartamentos = await apiService.fetchDepartamentosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedAlquileres = await apiService.fetchAlquileresByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedCasas = loadedCasasJson.map((json) => House.fromJson(json)).toList();

      if (!mounted) return;

      setState(() {
        casas = loadedCasas;
        filteredCasas = loadedCasas;
        hasCasas = loadedCasas.isNotEmpty;
        hasTerrenos = loadedTerrenos.isNotEmpty;
        hasDepartamentos = loadedDepartamentos.isNotEmpty;
        hasAlquileres = loadedAlquileres.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void filterCasas(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      searchText = query;
      filteredCasas = casas.where((casa) {
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

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '-';
    }
  }

  Future<void> _deleteCasa(int id, BuildContext context) async {
    try {
      final success = await ApiService.eliminarCasa(id);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa eliminada correctamente')),
        );
        loadAllData();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
                hintText: 'Buscar casas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterCasas,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCasas.isEmpty
                    ? Center(
                        child: Text(
                          widget.usuarioId != null
                              ? 'Sin casas publicadas.'
                              : 'No hay casas disponibles.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCasas.length,
                        itemBuilder: (context, index) {
                          final house = filteredCasas[index];
                          return HouseCard(
                            house: house,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleCasaScreen(
                                    casa: house,
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
                                ? () => _deleteCasa(house.id, context)
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
          onPressed: () async {
            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormHouseScreen(
                  idUsuario: widget.usuarioId!,
                  idCiudad: widget.cityId,
                ),
              ),
            );
            if (resultado == true) {
              await loadAllData();
            }
          },
        )
      : null,
    );
  }
}
