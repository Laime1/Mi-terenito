import 'package:flutter/material.dart';
import '../models/land.dart';
import '../screens/detalle_terreno_screen.dart';

class TerrenoCard extends StatelessWidget {
  final Land terreno;

  const TerrenoCard({Key? key, required this.terreno}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = terreno.images.isNotEmpty
        ? 'http://localhost:3000${terreno.images[0]}'
        : 'https://via.placeholder.com/120';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleTerrenoScreen(terreno: terreno),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terreno.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      terreno.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${terreno.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                    ),
                    const SizedBox(height: 8),
                    Text('Tamaño: ${terreno.size} m²'),
                    Text('Estado: ${terreno.status == 1 ? 'Disponible' : 'No disponible'}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}