import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/house.dart';

class HouseCard extends StatelessWidget {
  final House house;

  const HouseCard({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen principal
          if (house.images.isNotEmpty)
            Image.network(
              house.images.first,
              height: 180,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  house.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${house.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildFeatureItem(Icons.bed, '${house.bedrooms} hab.'),
                    _buildFeatureItem(Icons.bathtub, '${house.bathrooms} baños'),
                    _buildFeatureItem(Icons.garage, house.garage),
                    _buildFeatureItem(Icons.stairs, '${house.floors} pisos'),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Publicado: ${_formatDate(house.publishedAt)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}