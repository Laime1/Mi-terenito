import 'package:flutter/material.dart';
import '../models/apartment.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback? onTap;


  const ApartmentCard({super.key, required this.apartment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section (left side)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: apartment.images.isEmpty
                    ? const Center(
                        child: Icon(Icons.apartment, size: 60, color: Colors.grey),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
                        child: Image.network(
                          apartment.images.first,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            // Details section (right side)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apartment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apartment.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${apartment.price.toStringAsFixed(2)}',
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
                        _buildFeatureChip(Icons.bed, '${apartment.bedrooms} hab.'),
                        _buildFeatureChip(Icons.bathtub, '${apartment.bathrooms} baños'),
                        _buildFeatureChip(Icons.location_pin, '${apartment.city?.name}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Publicado: ${_formatDate(apartment.publishedAt)}',
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
        Icon(icon, size: 16,),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12,),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}