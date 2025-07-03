import 'package:flutter/material.dart';
import 'package:mi_terrenito/widgets/card_mixin.dart';
import '../models/house.dart';
import '../services/api_service.dart';
import '../models/app_colors.dart';
import '../models/app_fonts.dart';

class HouseCard extends StatelessWidget with CardMixin{
  final House house;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool enableSwipeActions;

  const HouseCard({
    super.key,
    required this.house,
    this.onTap,
    this.onDelete,
    this.onEdit,
    required this.enableSwipeActions,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl =
        house.images.isNotEmpty
            ? '${ApiService.baseImageUrl}${house.images.first}'
            : null;

    final cardContent = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              Icons.house,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        house.title,
                        style: AppFonts.montserratBold.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        house.description,
                        style: AppFonts.montserratRegular.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
                          _buildFeatureChip(
                            Icons.king_bed,
                            '${house.bedrooms} hab.',
                          ),
                          _buildFeatureChip(
                            Icons.bathtub,
                            '${house.bathrooms} baños',
                          ),
                          _buildFeatureChip(
                            Icons.garage,
                            '${house.garage ? 'Sí' : 'No'} garaje',
                          ),
                          _buildFeatureChip(
                            Icons.layers,
                            '${house.floors} pisos',
                          ),
                          if (house.city != null)
                            _buildFeatureChip(
                              Icons.location_pin,
                              house.city!.name,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Publicado: ${_formatDate(house.publishedAt)}',
                          style: AppFonts.montserratRegular.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // if (!enableSwipeActions) {
    //   return cardContent;
    // }

    return enableSwipeActions
        ? Dismissible(
          key: Key(house.id.toString()),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDialog<bool>(
              context: context,
              builder:
                  (ctx) => AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: const Text('¿Deseas eliminar esta casa?'),
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
            }else{
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

  Widget _buildFeatureChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
