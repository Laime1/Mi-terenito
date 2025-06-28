import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/apartment.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/table_card.dart';
import 'package:mi_terrenito/widgets/utils/app_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ApartmentDetailScreen extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailScreen({super.key, required this.apartment});

  void _openMapsApp() async {
    // Formatea la dirección para URLs (reemplaza espacios con '+')
    final Uri url = Uri.parse(apartment.mapLocation);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Manejo de error si no se puede abrir la URL
        const SnackBar(content: Text('No se pudo abrir Google Maps'));
    }
  }

  void _launchWhatsAppConMensaje(String phone, String mensaje) async {
    final whatsappUri = Uri.parse('whatsapp://send?phone=$phone&text=$mensaje');

    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      final webWhatsappUri = Uri.parse('https://wa.me/$phone?text=$mensaje');
      if (await canLaunchUrl(webWhatsappUri)) {
        await launchUrl(webWhatsappUri, mode: LaunchMode.externalApplication);
      } else {
            const SnackBar(content: Text('No se pudo abrir WhatsApp'));

      }
    }
  }
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
                  _buildLocationSection( context),
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
            //apartment.images[index],
            '${ApiService.baseImageUrl}${apartment.images[index]}',
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
    return RentalSpecificationsTable(
      bedrooms: apartment.bedrooms,
      bathrooms: apartment.bathrooms,
      city: apartment.city,
      company: apartment.company,
      username: apartment.user?.name,
      publishedAt: apartment.publishedAt,
      phone: apartment.company?.phone?.toString(),
      email: apartment.company?.email,
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
        if (apartment.mapLocation.isNotEmpty)
          InkWell(
            onTap: () => AppLauncher.openMaps(apartment.mapLocation, context),
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
        if (apartment.mapLocation.isEmpty)
          const Text(
            "Ubicación no disponible",
            style: TextStyle(color: Colors.grey),
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
            icon:  Icon(Icons.phone),
            onPressed: () {
              final rawPhone = apartment.user!.numberPhone.replaceAll(RegExp(r'\D'), '');
              final phone = rawPhone.length < 10 ? '+591$rawPhone' : rawPhone;

              if (phone.isNotEmpty) {
                final mensaje = Uri.encodeComponent(
                    'Hola, estoy interesado en "${apartment.title}" ubicado en "${apartment.mapLocation}". ¿Podría brindarme más información? 🏠'
                );
                _launchWhatsAppConMensaje(phone, mensaje);
              } else {
                  const SnackBar(content: Text('Número de contacto no disponible'));
              }
            },          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:  Icon(Icons.business, color: Colors.green),
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

}