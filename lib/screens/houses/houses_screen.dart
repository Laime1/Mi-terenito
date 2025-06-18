import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/house.dart';
import 'details_house_screen.dart';
import '../home2_screen.dart';
import 'form_house_screen.dart';

class CasasScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;
  final int? usuarioId;

  const CasasScreen({Key? key, required this.empresaId, required this.cityId, this.usuarioId}) : super(key: key);

  @override
  State<CasasScreen> createState() => _CasasScreenState();
}

class _CasasScreenState extends State<CasasScreen> {
  bool isLoading = true;
  List<dynamic> casas = [];
  List<dynamic> filteredCasas = [];
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
      List<dynamic> loadedCasas;

      if (widget.usuarioId != null) {
        loadedCasas = await apiService.fetchCasasByUsuario(widget.usuarioId!);
      } else {
        loadedCasas = await apiService.fetchCasasByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      }

      final loadedTerrenos = await apiService.fetchTerrenosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedDepartamentos = await apiService.fetchDepartamentosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      final loadedAlquileres = await apiService.fetchAlquileresByEmpresaAndCiudad(widget.empresaId, widget.cityId);

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
    setState(() {
      searchText = query.toLowerCase();
      filteredCasas = casas.where((casa) {
        final title = casa['titulo']?.toLowerCase() ?? '';
        final ciudad = casa['ciudad']?['nombre_ciudad']?.toLowerCase() ?? '';
        return title.contains(searchText) || ciudad.contains(searchText);
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
                          final casa = filteredCasas[index];
                          final imagenUrl = (casa['imagenes'] != null && casa['imagenes'].isNotEmpty)
                              ? '${ApiService.baseImageUrl}${casa['imagenes'][0]}'
                              : null;
                          final ciudad = casa['ciudad'] ?? {};

                          return GestureDetector(
                            onTap: () {
                              final houseModel = House.fromJson(casa);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleCasaScreen(casa: houseModel),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imagenUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          imagenUrl,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            casa['titulo'] ?? 'Sin título',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  ciudad['nombre_ciudad'] ?? '-',
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.king_bed, size: 20),
                                              const SizedBox(width: 4),
                                              Text('${casa['habitaciones'] ?? '-'} hab'),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.bathtub, size: 20),
                                              const SizedBox(width: 4),
                                              Text('${casa['banos'] ?? '-'} baños'),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '\$${casa['precio'] ?? '-'}',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
  child: const Icon(Icons.add),
  onPressed: () {
    if (widget.usuarioId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormHouseScreen(
            idUsuario: widget.usuarioId!,
            idCiudad: widget.cityId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo determinar el usuario para crear la casa')),
      );
    }
  },
),

    );
  }
}
