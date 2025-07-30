import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlMapField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const UrlMapField({
    Key? key,
    required this.controller,
    this.label = 'URL de mapa',
  }) : super(key: key);

  Future<void> _openMap(BuildContext context) async {
    final urlTexto = controller.text.trim();
    final Uri url = Uri.parse(
      urlTexto.isEmpty ? 'https://www.google.com/maps' : urlTexto,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }

  Future<void> _pasteFromClipboard(BuildContext context) async {
    final clipboardData = await Clipboard.getData('text/plain');
    final text = clipboardData?.text ?? '';
    if (text.isNotEmpty) {
      controller.text = text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL pegada desde portapapeles')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay texto en el portapapeles')),
      );
    }
  }

  Future<void> _setCurrentLocation(BuildContext context) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La ubicación no está disponible en esta plataforma')),
      );
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La ubicación está desactivada')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permisos permanentemente denegados')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final url = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      controller.text = url;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ubicación actual establecida')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener ubicación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        border: const OutlineInputBorder(gapPadding: 5),
        prefixIcon: IconButton(
          icon: const Icon(Icons.map, color: Colors.green),
          tooltip: 'Abrir en Google Maps',
          onPressed: () => _openMap(context),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.green),
              tooltip: 'Usar ubicación actual',
              onPressed: () => _setCurrentLocation(context),
            ),
            IconButton(
              icon: const Icon(Icons.paste, color: Colors.green),
              tooltip: 'Pegar desde portapapeles',
              onPressed: () => _pasteFromClipboard(context),
            ),
          ],
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
    );
  }
}
