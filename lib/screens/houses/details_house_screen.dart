import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/app_colors.dart';
import 'package:mi_terrenito/models/app_fonts.dart';
import '../../models/house.dart';
import '../../services/api_service.dart';
import '../../widgets/card_carrusel.dart';
import '../../widgets/table_card.dart';
import '../../widgets/utils/app_launcher.dart';
import '../houses/form_house_screen.dart';
//import 'package:mi_terrenito/models/app_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetalleCasaScreen extends StatelessWidget {
  final House casa;
  final int? usuarioId;

  const DetalleCasaScreen({super.key, required this.casa, this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          casa.title,
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
                    garage: casa.garage,
                    floors: casa.floors,
                    size: null,
                    basicServices: null,
                    furnished: null,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationSection(context),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(context),
                  const SizedBox(height: 24),
                  if (usuarioId != null && usuarioId == casa.user?.id) _buildActionButtons(context),
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
              CircleAvatar(child: Icon(Icons.map, color: Colors.white, size: 30)),
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
    final user = casa.user;
    final company = casa.company;
    final phoneRaw = user?.numberPhone.replaceAll(RegExp(r'\D'), '') ?? '';
    final phone = phoneRaw.length < 10 ? '+591$phoneRaw' : phoneRaw;
    final mensaje = Uri.encodeComponent('Hola, estoy interesado en "${casa.title}". ¿Podría brindarme más información sobre esta casa? 🏠');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Publicado por', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user?.name ?? 'No disponible'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company?.name ?? 'Empresa no disponible'),
              const SizedBox(height: 4),
              Text(user?.numberPhone ?? 'Teléfono no disponible'),
            ],
          ),
          trailing: GestureDetector(
  onTap: () {
    if (phone.isNotEmpty) {
      AppLauncher.launchWhatsApp(
        phone: phone,
        message: mensaje,
        context: context,
      );
    }
  },
  child: Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.green,
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
        color: Colors.white,
        size: 28,
      ),
    ),
  ),
),

        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(child: const Icon(Icons.business, color: Colors.white)),
          title: const Text('Información de la empresa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company?.description ?? 'Sin descripción'),
              const SizedBox(height: 4),
              Text('Teléfono: ${company?.phone ?? 'No disponible'}'),
              Text('Email: ${company?.email ?? 'No disponible'}'),
            ],
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
          textStyle: AppFonts.montserratRegular,
          backgroundColor: AppColors.navigationButtonBackground,
          foregroundColor: Colors.white, 
        ),
      ),
    );
  }
}
