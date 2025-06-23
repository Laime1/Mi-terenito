// utils/app_launcher.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  static Future<void> openMaps(String locationUrl, BuildContext context) async {
    if (locationUrl.isEmpty) {
      _showSnackBar(context, 'Ubicación no disponible');
      return;
    }

    final Uri url = Uri.parse(locationUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar(context, 'No se pudo abrir Google Maps');
      }
    } catch (e) {
      _showSnackBar(context, 'Error al abrir la ubicación');
    }
  }

  static Future<void> launchWhatsApp({
    required String phone,
    required String message,
    required BuildContext context,
  }) async {
    final cleanedPhone = phone.replaceAll(RegExp(r'\D'), '');
    final formattedPhone = cleanedPhone.length < 10 ? '+591$cleanedPhone' : cleanedPhone;

    if (formattedPhone.isEmpty) {
      _showSnackBar(context, 'Número de contacto no disponible');
      return;
    }

    final whatsappUri = Uri.parse('whatsapp://send?phone=$formattedPhone&text=${Uri.encodeComponent(message)}');
    final webWhatsappUri = Uri.parse('https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}');

    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        if (await canLaunchUrl(webWhatsappUri)) {
          await launchUrl(webWhatsappUri, mode: LaunchMode.externalApplication);
        } else {
          _showSnackBar(context, 'No se pudo abrir WhatsApp');
        }
      } catch (e) {
        _showSnackBar(context, 'Error al abrir WhatsApp');
      }
    }
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}