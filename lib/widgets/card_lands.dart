import 'package:flutter/material.dart';

class CardLands extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> lands;

  const CardLands({required this.title, required this.lands, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lands.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        const SizedBox(height: 8),
        ...lands.map((land) {
          return Card(
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(land['titulo'] ?? 'Sin título',
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(land['descripcion'] ?? 'Sin descripción',
                  style: const TextStyle(color: Colors.white70)),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
