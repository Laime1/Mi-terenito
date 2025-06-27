import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_terrenito/models/app_fonts.dart';
import 'package:mi_terrenito/models/land.dart';
import 'package:mi_terrenito/models/app_colors.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'package:mi_terrenito/widgets/card_carrusel.dart';
import 'package:mi_terrenito/widgets/utils/app_launcher.dart';
import 'package:mi_terrenito/widgets/table_card.dart';
import '../lands/form_land_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailLandScreen extends StatefulWidget {
  final Land terreno;
  final int? usuarioId;

  const DetailLandScreen({
    Key? key,
    required this.terreno,
    this.usuarioId,
  }) : super(key: key);

  @override
  State<DetailLandScreen> createState() => _DetailLandScreenState();
}

class _DetailLandScreenState extends State<DetailLandScreen> {
  @override
  Widget build(BuildContext context) {
    final terreno = widget.terreno;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navigationButtonBackground,
        title: Text(
          terreno.title,
          style: const TextStyle(
            color: AppColors.cardText,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.appBarText),
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
                    city: terreno.city,
                    size: terreno.size,
                    basicServices: terreno.basicServices,
                    bedrooms: null,
                    bathrooms: null,
                    garage: null,
                    floors: null,
                    furnished: null,
                    company: null,
                    username: null,
                    publishedAt: null,
                    phone: null,
                    email: null,
                    mapLocation: null,
                    mostrarSoloTerreno: true,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationSection(context),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(context),
                  const SizedBox(height: 24),
                  if (widget.usuarioId != null && widget.usuarioId == terreno.user?.id)
                    _buildEditButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.terreno.images;
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.landscape, size: 80, color: Colors.grey),
        ),
      );
    }
    final urls = images.map((img) => '${ApiService.baseImageUrl}$img').toList();
    return CardCarrusel(imageUrls: urls);
  }

  Widget _buildPriceSection() {
    return Text(
      '\$${widget.terreno.price.toStringAsFixed(2)}',
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
        Text(widget.terreno.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final location = widget.terreno.mapLocation ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (location.isNotEmpty)
          InkWell(
            onTap: () => AppLauncher.openMaps(location, context),
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

  Widget _buildPublisherInfo(BuildContext context) {
    final user = widget.terreno.user;
    final company = widget.terreno.company;
    final phoneRaw = user?.numberPhone.replaceAll(RegExp(r'\D'), '') ?? '';
    final phone = phoneRaw.length < 10 ? '+591$phoneRaw' : phoneRaw;
    final mensaje = Uri.encodeComponent(
        'Hola, estoy interesado en "${widget.terreno.title}". ¿Podrías brindarme más información sobre este terreno? 🌱');

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
                color: Colors.white,
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
          leading: const Icon(Icons.business),
          title: const Text(
            'Información de la empresa',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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

  Widget _buildEditButton(BuildContext context) {
    final user = widget.terreno.user;
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Editar'),
        style: ElevatedButton.styleFrom(
          textStyle: AppFonts.montserratRegular,
          backgroundColor: AppColors.navigationButtonBackground,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandFormScreen(
                idUser: user!.id,
                idCity: widget.terreno.city?.id ?? 0,
                idEmpresa: widget.terreno.company?.id ?? 0,
                land: widget.terreno,
              ),
            ),
          );
          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terreno actualizado')),
            );
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}
