import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/apartment.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/card_carrusel.dart';
import 'package:mi_terrenito/widgets/table_card.dart';
import 'package:mi_terrenito/widgets/utils/app_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ApartmentDetailScreen extends StatefulWidget {
  final Apartment apartment;

  const ApartmentDetailScreen({super.key, required this.apartment});

  @override
  State<ApartmentDetailScreen> createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> {
  late final List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = widget.apartment.images.map((img) => '${ApiService.baseImageUrl}$img').toList();
  }

  void _launchWhatsAppConMensaje(String phone, String mensaje) async {
    final whatsappUri = Uri.parse('whatsapp://send?phone=$phone&text=$mensaje');
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      final webWhatsappUri = Uri.parse('https://wa.me/$phone?text=$mensaje');
      if (await canLaunchUrl(webWhatsappUri)) {
        await launchUrl(webWhatsappUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apartment = widget.apartment;

    return Scaffold(
      appBar: AppBar(title: Text(apartment.title)),
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
                  _buildPriceSection(apartment),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(apartment),
                  const SizedBox(height: 16),
                  _buildFeaturesSection(apartment),
                  const SizedBox(height: 16),
                  _buildLocationSection(apartment),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(apartment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (imageUrls.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.apartment, size: 80, color: Colors.grey),
        ),
      );
    }

    return CardCarrusel(
      key: ValueKey(imageUrls.join()), // esto fuerza a reconstruir con nuevos datos
      imageUrls: imageUrls,
    );
  }

  Widget _buildPriceSection(Apartment apartment) {
    return Text(
      '\$${apartment.price}',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDescriptionSection(Apartment apartment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(apartment.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildFeaturesSection(Apartment apartment) {
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

  Widget _buildLocationSection(Apartment apartment) {
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
                Icon(Icons.map, color: Colors.blue[600], size: 30),
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
          )
        else
          const Text(
            "Ubicación no disponible",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildPublisherInfo(Apartment apartment) {
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
          trailing: GestureDetector(
            onTap: () {
              final rawPhone = apartment.user!.numberPhone.replaceAll(RegExp(r'\D'), '');
              final phone = rawPhone.length < 10 ? '+591$rawPhone' : rawPhone;

              if (phone.isNotEmpty) {
                final mensaje = Uri.encodeComponent(
                  'Hola, estoy interesado en "${apartment.title}" ubicado en "${apartment.mapLocation}". ¿Podría brindarme más información? 🏠',
                );
                _launchWhatsAppConMensaje(phone, mensaje);
              } else {
                  const SnackBar(content: Text('Número de contacto no disponible'));
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Color.fromARGB(255, 48, 100, 27),
                  size: 28,
                ),
              ),
            ),
          ),
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