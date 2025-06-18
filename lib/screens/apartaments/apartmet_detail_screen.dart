import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/apartment.dart';
import 'package:mi_terrenito/widgets/table_card.dart';

class ApartmentDetailScreen extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(apartment.title)),
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
                  _buildFeaturesSection(),
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
      child: apartment.images.isEmpty
          ? Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.apartment, size: 80, color: Colors.grey),
        ),
      )
          : PageView.builder(
        itemCount: apartment.images.length,
        itemBuilder: (context, index) {
          return Image.network(
            apartment.images[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${apartment.price}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildFeatureItem(Icons.bed, '${apartment.bedrooms} Habitaciones'),
            _buildFeatureItem(Icons.bathtub, '${apartment.bathrooms} Baños'),
            _buildFeatureItem(Icons.location_city, apartment.city!.name),
          ],
        ),
      ],
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
        Text(
          apartment.description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Características',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildFeatureTableCell('Habitaciones', apartment.bedrooms.toString()),
                _buildFeatureTableCell('Baños', apartment.bathrooms.toString()),
              ],
            ),
            TableRow(
              children: [
                _buildFeatureTableCell('Ciudad', apartment.city!.name),
                _buildFeatureTableCell('Publicado', _formatDate(apartment.publishedAt)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureTableCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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
                if (apartment.mapLocation.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        // Abrir enlace de ubicación
                        // Puedes usar url_launcher para esto
                      },
                      child: const Icon(Icons.navigation),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (apartment.mapLocation.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              apartment.mapLocation,
              style: TextStyle(
                color: Colors.blue[600],
                decoration: TextDecoration.underline,
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
          title: Text(apartment.user!.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(apartment.company!.name),
              const SizedBox(height: 4),
              Text(apartment.user!.numberPhone),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // Lógica para llamar al contacto
            },
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.business),
          title: const Text('Información de la empresa'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(apartment.company!.description),
              const SizedBox(height: 4),
              Text('Teléfono: ${apartment.company!.phone}'),
              Text('Email: ${apartment.company!.email}'),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}