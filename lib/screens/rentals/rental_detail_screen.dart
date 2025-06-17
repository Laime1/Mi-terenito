import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/rental.dart';
import 'package:mi_terrenito/widgets/table_card.dart';

class RentalDetailScreen extends StatelessWidget {
  final Rental rental;

  const RentalDetailScreen({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rental.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de imágenes
            _buildImageGallery(),

            // Sección de información principal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Precio y características principales
                  _buildPriceSection(),
                  const SizedBox(height: 16),

                  // Descripción completa
                  _buildDescriptionSection(),
                  const SizedBox(height: 16),

                  // Características detalladas
          RentalSpecificationsTable(rental: rental),
                  const SizedBox(height: 16),

                  // Ubicación
                  _buildLocationSection(),
                  const SizedBox(height: 16),

                  // Información del publicador
                  _buildPublisherInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 250,
      child:
          rental.images.isEmpty
              ? Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.home, size: 80, color: Colors.grey),
                ),
              )
              : PageView.builder(
                itemCount: rental.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    rental.images[index],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                  );
                },
              ),
    );
  }

  Widget _buildPriceSection() {
    return Text(
      '\$${rental.monthlyPrice.toStringAsFixed(2)}/mes',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(rental.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  // Widget _buildFeaturesSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Características',
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 12),
  //       Wrap(
  //         spacing: 12,
  //         runSpacing: 12,
  //         children: [
  //           _buildFeatureItem(
  //             Icons.checkroom,
  //             'Amoblado: ${rental.furnished == 'Sí' ? 'Sí' : 'No'}',
  //           ),
  //           _buildFeatureItem(
  //             Icons.construction,
  //             'Servicios: ${rental.includedServices == 'Sí' ? 'Incluidos' : 'No incluidos'}',
  //           ),
  //           _buildFeatureItem(
  //             Icons.business,
  //             'Empresa: ${rental.company.name}',
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Mapa de ubicación (puedes reemplazar con un paquete de mapas real)
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.map, size: 60, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      // Abrir enlace de ubicación
                    },
                    child: const Icon(Icons.navigation),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Publicado por',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(rental.user.name),
          subtitle: Text(rental.company.name),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
