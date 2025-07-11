import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_terrenito/widgets/card_mixin.dart';
import '../models/land.dart';
import '../services/api_service.dart';

class LandCard extends StatelessWidget with CardMixin {
  final Land land;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool enableSwipeActions;

  const LandCard({
    Key? key,
    required this.land,
    this.onTap,
    this.onDelete,
    this.enableSwipeActions = false, this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? imageUrl =
        land.images.isNotEmpty
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
                child:
                    imageUrl == null
                        ? const Center(
                          child: Icon(
                            Icons.terrain,
                            size: 60,
                            color: Colors.grey,
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
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
                        fontWeight: FontWeight.w400,
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
                        _buildFeatureChip(
                          Icons.square_foot,
                          '${land.size > 0 ? land.size.toStringAsFixed(2) : 'N/A'} m²',
                        ),
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

    return enableSwipeActions
        ? Dismissible(
          key: Key(land.id.toString()),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Confirmar eliminación'),
                      content: const Text('¿Deseas eliminar este terreno?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
              );
            } else {
              onEdit?.call();
              return false;
            }
          },
          background: buildSwipeBackground(true),
          secondaryBackground: buildSwipeBackground(false),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onDelete?.call();
            }
          },

          child: card,
        )
        : card;
  }

  Widget _buildFeatureChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
