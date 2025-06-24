import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/app_colors.dart';
import '../../models/house.dart';
import '../../services/api_service.dart';
import '../../widgets/card_carrusel.dart';
import '../../widgets/table_card.dart';
import '../../widgets/utils/app_launcher.dart';
import '../houses/form_house_screen.dart';
import 'package:mi_terrenito/models/app_fonts.dart';

class DetalleCasaScreen extends StatelessWidget {
  final House casa;

  const DetalleCasaScreen({super.key, required this.casa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navigationButtonBackground,
        title: Text(
          casa.title,
          style: TextStyle(
            color: AppColors.cardText,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.appBarText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceSection(),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(),
                  const SizedBox(height: 16),
                  RentalSpecificationsTable(
                    bedrooms: casa.bedrooms,
                    bathrooms: casa.bathrooms,
                    garage: casa.garage == 1,
                    floors: casa.floors,
                    size: null,
                    services: null,
                    furnished: null,
                    city: casa.city,
                    company: casa.company,
                    username: casa.user?.name,
                    publishedAt: casa.publishedAt,
                    phone: casa.user?.numberPhone,
                    email: casa.user?.email,
                    mapLocation: casa.mapLocation,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationSection(context),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(context),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (casa.images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.home, size: 80, color: Colors.grey),
        ),
      );
    }
    final urls = casa.images.map((img) => '${ApiService.baseImageUrl}$img').toList();
    return CardCarrusel(imageUrls: urls);
  }

  Widget _buildPriceSection() {
    return Text(
      '\$${casa.price.toStringAsFixed(2)} / venta',
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
        Text(casa.description, style: const TextStyle(fontSize: 16)),
      ],
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
            AppLauncher.openMaps(casa.mapLocation, context);
          },
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
        ),
      ],
    );
  }

  Widget _buildPublisherInfo(BuildContext context) {
    final mensaje = 'Hola, estoy interesado en "${casa.title}" ubicado en "${casa.mapLocation}". ¿Podría brindarme más información? 🏠';

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
          title: Text(casa.user?.name ?? 'Nombre no disponible'),
          subtitle: Text(casa.company?.name ?? 'Empresa no disponible'),
          trailing: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              AppLauncher.launchWhatsApp(
                phone: casa.user?.numberPhone ?? '',
                message: mensaje,
                context: context,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormHouseScreen(
                idUsuario: casa.user?.id ?? 0,
                idCiudad: casa.city?.id ?? 0,
                house: casa,
              ),
            ),
          );
          if (resultado == true) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Casa actualizada')),
              );
            }
            Navigator.pop(context, true);
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text('Editar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navigationButtonBackground,
        ),
      ),
    );
  }
}
