import 'package:flutter/material.dart';
import '../models/house.dart';
import '../services/api_service.dart';

class HouseCard extends StatelessWidget {
  final House house;
  final VoidCallback? onTap;

  const HouseCard({
    super.key,
    required this.house,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = house.images.isNotEmpty
        ? '${ApiService.baseImageUrl}${house.images.first}'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: imageUrl == null
                    ? const Center(
                        child: Icon(Icons.house, size: 60, color: Colors.grey),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  size: 60, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            // Detalles
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      house.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${house.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildFeatureChip(Icons.king_bed,
                            '${house.bedrooms} hab.'),
                        _buildFeatureChip(Icons.bathtub,
                            '${house.bathrooms} baños'),
                        _buildFeatureChip(Icons.garage,
                            '${house.garage} garaje'),
                        _buildFeatureChip(Icons.layers,
                            '${house.floors} pisos'),
                        if (house.city != null)
                          _buildFeatureChip(
                              Icons.location_pin, house.city!.name),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Publicado: ${_formatDate(house.publishedAt)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: Colors.grey[300],
          child: Icon(icon, size: 12, color: Colors.black),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
