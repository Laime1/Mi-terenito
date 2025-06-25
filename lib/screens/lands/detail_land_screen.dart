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
        title: Text(terreno.title),
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
                  _buildPrice(),
                  const SizedBox(height: 16),
                  _buildDescription(),
                  const SizedBox(height: 16),
                  RentalSpecificationsTable(
                    city: terreno.city,
                    company: terreno.company,
                    username: terreno.user?.name,
                    publishedAt: terreno.createdAt,
                    phone: terreno.user?.numberPhone,
                    email: terreno.user?.email,
                    basicServices: terreno.basicServices,
                    mapLocation: terreno.mapLocation,
                    size: terreno.size,
                  ),
                  const SizedBox(height: 16),
                  _buildPublisherInfo(context),
                  const SizedBox(height: 24),
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

  Widget _buildPrice() {
    return Text(
      '\$${widget.terreno.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descripción', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(widget.terreno.description),
      ],
    );
  }

  Widget _buildPublisherInfo(BuildContext context) {
    final user = widget.terreno.user;
    final company = widget.terreno.company;
    final phoneRaw = user?.numberPhone.replaceAll(RegExp(r'\D'), '') ?? '';
    final phone = phoneRaw.length < 10 ? '+591$phoneRaw' : phoneRaw;
    final mensaje = Uri.encodeComponent('Hola, estoy interesado en "${widget.terreno.title}". ¿Podría brindarme más información sobre este terreno? 🌱');

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
          trailing: IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              if (phone.isNotEmpty) {
                AppLauncher.launchWhatsApp(
                  phone: phone,
                  message: mensaje,
                  context: context,
                );
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.business),
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

  Widget _buildEditButton(BuildContext context) {
    final user = widget.terreno.user;
    if (widget.usuarioId == null || user == null || widget.usuarioId != user.id) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Editar'),
        style: ElevatedButton.styleFrom(
          textStyle: AppFonts.montserratRegular,
          backgroundColor: AppColors.navigationButtonBackground,
          foregroundColor: Colors.white, 
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandFormScreen(
                idUser: user.id,
                idCity: widget.terreno.city?.id ?? 0,
                idEmpresa: widget.terreno.company?.id ?? 0,
                land: widget.terreno,
              ),
            ),
          );
          if (resultado == true && context.mounted) {
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
