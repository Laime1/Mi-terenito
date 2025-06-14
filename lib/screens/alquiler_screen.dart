import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AlquileresScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const AlquileresScreen({
    Key? key,
    required this.empresaId,
    required this.cityId,
  }) : super(key: key);

  @override
  State<AlquileresScreen> createState() => _AlquileresScreenState();
}

class _AlquileresScreenState extends State<AlquileresScreen> {
  bool isLoading = true;
  List<dynamic> alquileres = [];
  final ApiService apiService = ApiService();

  // Cambia por la IP y puerto de tu backend
  final String baseUrlImagenes = 'http://<TU_IP>:3000';

  @override
  void initState() {
    super.initState();
    cargarAlquileres();
  }

  Future<void> cargarAlquileres() async {
    try {
      final data = await apiService.fetchAlquileresByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        alquileres = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar alquileres: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alquileres'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alquileres.isEmpty
              ? const Center(child: Text('No hay alquileres disponibles.'))
              : ListView.builder(
                  itemCount: alquileres.length,
                  itemBuilder: (context, index) {
                    final alquiler = alquileres[index];
                    final imagenPath = (alquiler['imagenes'] != null && alquiler['imagenes'].isNotEmpty)
                        ? alquiler['imagenes'][0]
                        : null;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: imagenPath != null
                            ? Image.network(
                                baseUrlImagenes + imagenPath,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported, size: 80),
                        title: Text(alquiler['titulo'] ?? 'Sin título'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alquiler['descripcion'] ?? ''),
                            const SizedBox(height: 4),
                            // No viene precio en alquileres? Si tienes, agrega aquí
                            // Text('Precio: \$${alquiler['precio']}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
