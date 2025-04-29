import 'package:flutter/material.dart';
import '../models/property.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  property.images.first.url,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Miniaturas de imágenes
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: property.images.map((img) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 4),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(8),
            //         child: Image.network(
            //           img,
            //           height: 50,
            //           width: 50,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            // const SizedBox(height: 16),
            // Precios
            Text(
              '\$ ${property.minPrice} - \$ ${property.maxPrice}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            // Descripción
            const Text(
              'Descripción de Terreno',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              property.description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            // Tamaño
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(
                    text: 'Tamaño: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${property.size} m²',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Zona
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(
                    text: 'Zona: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: property.zone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Contactos
            const Text(
              'Números de Contacto:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              '6543216 - 76543211',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            // Botones de contacto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text('Contacto'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map),
                  label: const Text('Ubicación'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Botones de editar y eliminar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text('Editar', style: TextStyle(color: Colors.blue)),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
