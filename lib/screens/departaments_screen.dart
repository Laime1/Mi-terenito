import 'package:flutter/material.dart';
import '../models/apartament.dart';
import '../services/api_service.dart';
//import 'detalle_departamento_screen.dart';

class DepartmentsScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const DepartmentsScreen({Key? key, required this.empresaId, required this.cityId}) : super(key: key);

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  bool isLoading = true;
  List<dynamic> departamentos = [];
  List<dynamic> filteredDepartamentos = [];
  String searchText = '';

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadDepartamentos();
  }

  Future<void> loadDepartamentos() async {
    try {
      final loaded = await apiService.fetchDepartamentosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        departamentos = loaded;
        filteredDepartamentos = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterDepartamentos(String query) {
    setState(() {
      searchText = query.toLowerCase();
      filteredDepartamentos = departamentos.where((item) {
        final title = item['titulo']?.toLowerCase() ?? '';
        final ciudad = item['ciudad']?['nombre_ciudad']?.toLowerCase() ?? '';
        return title.contains(searchText) || ciudad.contains(searchText);
      }).toList();
    });
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
                hintText: 'Buscar departamentos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: filterDepartamentos,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredDepartamentos.isEmpty
                    ? const Center(child: Text('No hay departamentos disponibles.'))
                    : ListView.builder(
                        itemCount: filteredDepartamentos.length,
                        itemBuilder: (context, index) {
                          final depto = filteredDepartamentos[index];
                          final imagenUrl = (depto['imagenes'] != null && depto['imagenes'].isNotEmpty)
                              ? 'http://localhost:3000${depto['imagenes'][0]}'
                              : null;
                          final ciudad = depto['ciudad'] ?? {};

                          return GestureDetector(
                            onTap: () {
                              // final departamento = Department.fromJson(depto);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => DetalleDepartamentoScreen(departamento: departamento),
                              //   ),
                              // );
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
                                            depto['titulo'] ?? 'Sin título',
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
                                              Text('${depto['habitaciones'] ?? '-'} hab'),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.bathtub, size: 20),
                                              const SizedBox(width: 4),
                                              Text('${depto['banos'] ?? '-'} baños'),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '\$${depto['precio'] ?? '-'}',
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
    );
  }
}
