import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/land.dart';
import '../services/api_service.dart';

class LandCard extends StatelessWidget {
  final Land land;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool enableSwipeActions;

  const LandCard({
    Key? key,
    required this.land,
    this.onTap,
    this.onDelete,
    this.enableSwipeActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = land.images.isNotEmpty
        ? '${ApiService.baseImageUrl}${land.images.first}'
        : null;

    final card = Card(
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
                        child: Icon(Icons.terrain, size: 60, color: Colors.grey),
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
                      land.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      land.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${NumberFormat('#,##0.00').format(land.price)}',
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
                        if (land.city != null)
                          _buildFeatureChip(Icons.location_on, land.city!.name),
                        _buildFeatureChip(Icons.square_foot,
                            '${land.size > 0 ? land.size.toStringAsFixed(2) : 'N/A'} m²'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Publicado: ${_formatDate(land.publishedAt)}',
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

    if (!enableSwipeActions) return card;

    return Dismissible(
      key: Key(land.id.toString()),
      direction: DismissDirection.endToStart,  // Solo permite deslizar hacia la izquierda
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart && onDelete != null) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirmar eliminación'),
              content: const Text('¿Quieres eliminar este terreno?'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
              ],
            ),
          );
          if (confirm == true) {
            onDelete!();
          }
          return confirm;
        }
        return false;
      },
      child: card,
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

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
