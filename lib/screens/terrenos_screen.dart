import 'package:flutter/material.dart';
import '../services/api_service.dart';


class TerrenosScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const TerrenosScreen({Key? key, required this.empresaId, required this.cityId}) : super(key: key);

  @override
  State<TerrenosScreen> createState() => _TerrenosScreenState();
}

class _TerrenosScreenState extends State<TerrenosScreen> {
  bool isLoading = true;
  List<dynamic> terrenos = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadTerrenos();
  }

  Future<void> loadTerrenos() async {
    try {
      final loadedTerrenos = await apiService.fetchTerrenosByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        terrenos = loadedTerrenos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terrenos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : terrenos.isEmpty
              ? const Center(child: Text('No hay terrenos disponibles para esta empresa y ciudad.'))
              : ListView.builder(
                  itemCount: terrenos.length,
                  itemBuilder: (context, index) {
                    final terreno = terrenos[index];
                    final imagenUrl = (terreno['imagenes'] != null && terreno['imagenes'].isNotEmpty)
                        ? 'http://localhost:3000${terreno['imagenes'][0]}'
                        : null;

                    final usuario = terreno['usuario'] ?? {};
                    final ciudad = terreno['ciudad'] ?? {};
                    final empresa = terreno['empresa'] ?? {};

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (imagenUrl != null)
                              Image.network(
                                imagenUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            const SizedBox(height: 8),
                            Text(
                              terreno['titulo'] ?? 'Sin título',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(terreno['descripcion'] ?? ''),
                            const SizedBox(height: 8),
                            Text('Precio: \$${terreno['precio'] ?? '-'}'),
                            Text('Estado: ${terreno['estado'] == 1 ? 'Disponible' : 'No disponible'}'),
                            Text('Fecha publicación: ${DateTime.tryParse(terreno['fecha_publicacion'] ?? '')?.toLocal().toString().split(' ')[0] ?? '-'}'),
                            const SizedBox(height: 8),
                            Text('Tamaño: ${terreno['tamano'] ?? '-'} m²'),
                            Text('Servicios básicos: ${terreno['servicios_basicos'] ?? 'No'}'),
                            const SizedBox(height: 8),
                            Text('Usuario: ${usuario['nombre_usuario'] ?? '-'}'),
                            Text('Contacto: ${usuario['contacto'] ?? '-'}'),
                            const SizedBox(height: 8),
                            Text('Ciudad: ${ciudad['nombre_ciudad'] ?? '-'}'),
                            Text('Empresa: ${empresa['nombre_empresa'] ?? '-'}'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                final url = terreno['enlace_ubicacion'];
                                if (url != null && url.isNotEmpty) {
                              
                                }
                              },
                              child: Text(
                                'Ver ubicación',
                                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
