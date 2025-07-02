import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/rental.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/card_carrusel.dart';
import 'package:mi_terrenito/widgets/table_card.dart';
import 'package:mi_terrenito/widgets/utils/app_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RentalDetailScreen extends StatefulWidget {
  final Rental rental;

  const RentalDetailScreen({super.key, required this.rental});

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  late final List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = widget.rental.images.map((img) => '${ApiService.baseImageUrl}$img').toList();
  }

  @override
  Widget build(BuildContext context) {
    final rental = widget.rental;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          maxLines: 3,
          rental.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
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
                  _buildPriceSection(rental),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(rental),
                  const SizedBox(height: 16),
                  _buildFeaturesSection(rental),
                  const SizedBox(height: 16),
                  _buildLocationSection(rental, context),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(rental, context),
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
          child: Icon(Icons.home, size: 80, color: Colors.grey),
        ),
      );
    }

    return CardCarrusel(
      key: ValueKey(imageUrls.join()), // fuerza recreación si cambian
      imageUrls: imageUrls,
    );
  }

  Widget _buildPriceSection(Rental rental) {
    return Text(
      '\$${rental.monthlyPrice.toStringAsFixed(2)}/mes',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDescriptionSection(Rental rental) {
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

  Widget _buildFeaturesSection(Rental rental) {
    return RentalSpecificationsTable(
      furnished: rental.furnished == 'Sí',
      basicServices: rental.includedServices,

    );
  }

  Widget _buildLocationSection(Rental rental, BuildContext context) {
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
              CircleAvatar(
                child: Icon(
                  Icons.map,
                  color: Colors.white,
                  size: 30,
                ),
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

  Widget _buildPublisherInfo(Rental rental, BuildContext context) {
    final propertyInfo = 'Hola, estoy interesado en "${rental.title}" ubicado en "${rental.mapLocation}". ¿Podría brindarme más información? 🏠';
    final company = widget.rental.company;

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
          leading: const CircleAvatar(child: Icon(Icons.person, color: Colors.white,)),
          title: Text(rental.user.name),
          subtitle: Text(rental.company.name),
          trailing: GestureDetector(
            onTap: () {
              AppLauncher.launchWhatsApp(
                phone: rental.user.numberPhone.toString(),
                message: propertyInfo,
                context: context,
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green,
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
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),

          ),

        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:  CircleAvatar(child: Icon(Icons.business, color: Colors.white)),
          title: const Text(
            'Información de la empresa',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.description ?? 'Sin descripción'),
              const SizedBox(height: 4),
              Text('Teléfono: ${company.phone ?? 'No disponible'}'),
              Text('Email: ${company.email ?? 'No disponible'}'),
            ],
          ),
        ),
      ],
    );
  }
}
