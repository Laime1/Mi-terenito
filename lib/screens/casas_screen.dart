import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CasasScreen extends StatefulWidget {
  final int empresaId;
  final int cityId;

  const CasasScreen({Key? key, required this.empresaId, required this.cityId}) : super(key: key);

  @override
  State<CasasScreen> createState() => _CasasScreenState();
}

class _CasasScreenState extends State<CasasScreen> {
  bool isLoading = true;
  List<dynamic> casas = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadCasas();
  }

  Future<void> loadCasas() async {
    try {
      final loadedCasas = await apiService.fetchCasasByEmpresaAndCiudad(widget.empresaId, widget.cityId);
      setState(() {
        casas = loadedCasas;
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
        title: const Text('Casas'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : casas.isEmpty
              ? const Center(child: Text('No hay casas disponibles para esta empresa y ciudad.'))
              : ListView.builder(
  itemCount: casas.length,
  itemBuilder: (context, index) {
    final casa = casas[index];
    final imagenUrl = (casa['imagenes'] != null && casa['imagenes'].isNotEmpty)
        ? 'http://localhost:3000${casa['imagenes'][0]}'
        : null;

    final usuario = casa['usuario'] ?? {};
    final ciudad = casa['ciudad'] ?? {};
    final empresa = casa['empresa'] ?? {};

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
              casa['titulo'] ?? 'Sin título',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(casa['descripcion'] ?? ''),
            const SizedBox(height: 8),
            Text('Precio: \$${casa['precio'] ?? '-'}'),
            Text('Estado: ${casa['estado'] == 1 ? 'Disponible' : 'No disponible'}'),
            Text('Fecha publicación: ${DateTime.tryParse(casa['fecha_publicacion'] ?? '')?.toLocal().toString().split(' ')[0] ?? '-'}'),
            const SizedBox(height: 8),
            Text('Habitaciones: ${casa['habitaciones'] ?? '-'}'),
            Text('Baños: ${casa['banos'] ?? '-'}'),
            Text('Cochera: ${casa['cochera'] ?? '-'}'),
            Text('Pisos: ${casa['pisos'] ?? '-'}'),
            const SizedBox(height: 8),
            Text('Usuario: ${usuario['nombre_usuario'] ?? '-'}'),
            Text('Contacto: ${usuario['contacto'] ?? '-'}'),
            const SizedBox(height: 8),
            Text('Ciudad: ${ciudad['nombre_ciudad'] ?? '-'}'),
            Text('Empresa: ${empresa['nombre_empresa'] ?? '-'}'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                final url = casa['enlace_ubicacion'];
                if (url != null && url.isNotEmpty) {
                  // Aquí puedes usar url_launcher para abrir el enlace
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