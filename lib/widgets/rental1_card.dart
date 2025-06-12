import 'package:flutter/material.dart';
import '../models/Rent.dart';

class RentalCard extends StatelessWidget {
  final Rental rental;

  const RentalCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rental.images.isNotEmpty)
            Expanded(
              child: Image.network(
                rental.images.first,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rental.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(rental.description),
                  const SizedBox(height: 12),
                  Text(
                    '\$${rental.monthlyPrice.toStringAsFixed(2)}/mes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      // _buildFeatureItem('Amoblado: ${rental.furnished}'),
                      // _buildFeatureItem('Mínimo: ${rental.minimumMonths} meses'),
                      // _buildFeatureItem('Servicios: ${rental.includedServices}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Publicado: ${_formatDate(rental.publishedAt)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}