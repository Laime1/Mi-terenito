import 'package:flutter/material.dart';
import '../models/property.dart';


class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name, style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  property.images.first,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Miniaturas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: property.images.take(3).map((img) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Precio
            Text(
              '\$ ${property.minPrice} - \$ ${property.maxPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción
            const Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              property.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Tamaño y zona
            Text(
              'Tamaño: ${property.size} m²\nZona: ${property.zone}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Contactos
            const Text(
              'Contacto:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('6543216 - 76543211', style: TextStyle(fontSize: 14)),

            const Spacer(),

            // Botones contacto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map, size: 18),
                  label: const Text('Mapa'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 176, 34, 34),
        unselectedItemColor: const Color.fromARGB(221, 4, 43, 239),
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Editar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Eliminar',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Acción de Editar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Editar presionado')),
            );
          } else if (index == 1) {
            // Acción de Eliminar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Eliminar presionado')),
            );
          }
        },
      ),
    );
  }
}
