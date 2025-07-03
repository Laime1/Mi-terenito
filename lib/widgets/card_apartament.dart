import 'package:flutter/material.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/card_mixin.dart';
import '../models/apartment.dart';
import '../services/api_service.dart';

class ApartmentCard extends StatelessWidget with CardMixin{
  final Apartment apartment;
  final VoidCallback? onTap;
  final Function()? onDelete;
  final Function()? onEdit;
  final bool enableSwipeActions;


  const ApartmentCard({super.key, required this.apartment, required this.onTap, this.onDelete, this.onEdit, required this.enableSwipeActions});

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
                    borderRadius:  BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: apartment.images.isEmpty
                      ? const Center(
                          child: Icon(Icons.apartment, size: 60, color: Colors.grey),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            12
                          ),
                          child: Image.network(
                            '${ApiService.baseImageUrl}${apartment.images.first}',
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
                          fontWeight: FontWeight.w400,
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
                          buildFeatureChip(Icons.bed, '${apartment.bedrooms} hab.'),
                          buildFeatureChip(Icons.bathtub, '${apartment.bathrooms} baños'),
                          buildFeatureChip(Icons.location_pin, '${apartment.city?.name}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Publicado: ${formatDate(apartment.publishedAt)}',
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
      key: Key(apartment.id.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDeleteConfirmation(context, 'apartamento');
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
