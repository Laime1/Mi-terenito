import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        suffixIcon: IconButton(
          icon: const Icon(Icons.paste, color: Colors.green),
          tooltip: 'Pegar desde portapapeles',
          onPressed: () => _pasteFromClipboard(context),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
    );
  }
}
