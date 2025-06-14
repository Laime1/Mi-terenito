import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/land.dart';

class DetalleTerrenoScreen extends StatelessWidget {
  final Land terreno;

  const DetalleTerrenoScreen({Key? key, required this.terreno}) : super(key: key);

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = terreno.images.isNotEmpty ? 'http://localhost:3000${terreno.images.first}' : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(terreno.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagenUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imagenUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              ),

            const SizedBox(height: 20),

            Text(
              terreno.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              terreno.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  '\$${terreno.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.map),
                const SizedBox(width: 8),
                Text('Tamaño: ${terreno.size} m²'),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.build_circle_outlined),
                const SizedBox(width: 8),
                Text('Servicios básicos: ${terreno.basicServices}'),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text('Publicado el: ${formatDate(terreno.publishedAt)}'),
              ],
            ),

            const SizedBox(height: 10),

           // Text('Usuario: ${terreno.user.nombreUsuario}'),
            //Text('Contacto: ${terreno.user.contacto}'),

            const SizedBox(height: 10),

            Text('Ciudad ID: ${terreno.idCiudad}'),
            Text('Usuario ID: ${terreno.idUsuario}'),

            // Puedes agregar más campos que tengas en el modelo Land

            const SizedBox(height: 20),

            if (terreno.mapLocation.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // Aquí puedes implementar abrir URL de ubicación con url_launcher, si quieres
                },
                child: Text(
                  'Ver ubicación en mapa',
                  style: TextStyle(
                    color: Colors.blue[700],
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}