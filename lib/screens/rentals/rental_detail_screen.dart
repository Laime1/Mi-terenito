import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/rental.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/table_card.dart';
import 'package:mi_terrenito/services/api_service.dart';

import '../../widgets/utils/app_launcher.dart';

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
            _buildImageGallery(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceSection(),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(),
                  const SizedBox(height: 16),
                  _buildFeaturesSection(),
                  const SizedBox(height: 16),
                  _buildLocationSection(context),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(context),
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
      child: rental.images.isEmpty
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
            '${ApiService.baseImageUrl}${rental.images[index]}',
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

  Widget _buildFeaturesSection() {
    return RentalSpecificationsTable(
      furnished: rental.furnished == 'Sí',
      basicServices: rental.includedServices,
      city: rental.city,
      company: rental.company,
      publishedAt: rental.publishedAt,
      phone: rental.company.phone.toString(),
      email: rental.company.email,
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            AppLauncher.openMaps(rental.mapLocation, context);
          },
          child: Row(
            children: [
              Icon(
                Icons.map,
                color: Colors.blue[600],
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                "Ver en Maps",
                style: TextStyle(
                  color: Colors.blue[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherInfo(BuildContext context) {
    final propertyInfo = 'Hola, estoy interesado en "${rental.title}" ubicado en "${rental.mapLocation}". ¿Podría brindarme más información? 🏠';

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
          trailing: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              AppLauncher.launchWhatsApp(
                phone: rental.user.numberPhone.toString(),
                message: propertyInfo,
                context: context,
              );
            },
          ),
        ),
      ],
    );
  }
}