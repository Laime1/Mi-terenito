import 'package:flutter/material.dart';
import '../models/property/property.dart';
import '../screens/property_detail_screen.dart';
import 'package:mi_terrenito/models/app_colors.dart';


class PropertyCard extends StatelessWidget {
  final Property property;
  final int? idUsuario;

  const PropertyCard({super.key, required this.property, this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailScreen(
                property: property,
                idUsuario: idUsuario,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration:  BoxDecoration(
              color: AppColors.cardBackground, // Fondo verde oscuro
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      property.images.first.url,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: AppColors.cardText, // Texto blanco
                          ),
                        ),
                        Text(
                          property.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.cardText, // Texto blanco
                          ),
                        ),
                        Text(
                          '${property.size.toInt()} m²',
                          style: const TextStyle(
                            color: AppColors.cardText, // Texto blanco
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "\$${property.minPrice} - \$${property.maxPrice}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.cardText, // Texto blanco
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}