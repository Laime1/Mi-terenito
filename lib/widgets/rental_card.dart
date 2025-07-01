
import 'package:flutter/material.dart';
import 'package:mi_terrenito/services/api_service.dart';
import '../models/rental.dart';
import 'card_mixin.dart';

class RentalCard extends StatelessWidget with CardMixin {
  final Rental rental;
  final VoidCallback? onTap;
  final Function()? onDelete;
  final Function()? onEdit;
  final bool enableSwipeActions;

  const RentalCard({
    super.key,
    required this.rental,
    this.onTap, this.onDelete, this.onEdit, required this.enableSwipeActions,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
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
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: rental.images.isEmpty
                      ? const Center(
                          child: Icon(Icons.home, size: 60, color: Colors.grey),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            //rental.images.first,
                            '${ApiService.baseImageUrl}${rental.images.first}',
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
                        rental.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rental.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${rental.monthlyPrice.toStringAsFixed(2)}/mes',
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
                          buildFeatureChip(
                            Icons.checkroom,
                            rental.furnished == 'Sí'? 'Amoblado' : 'Sin amoblar',
                          ),

                          buildFeatureChip(
                            Icons.construction,
                            rental.includedServices == 'Sí' ? 'Con servicios' : 'Sin servicios',
                          ),
                          buildFeatureChip(
                            Icons.location_pin,
                            rental.city.name,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Publicado: ${formatDate(rental.publishedAt)}',
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
      key: Key(rental.id.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDeleteConfirmation(context, 'alquiler');
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
      child: cardContent,
    )
        : cardContent;
  }
}
