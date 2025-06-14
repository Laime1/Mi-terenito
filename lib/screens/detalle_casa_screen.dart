import 'package:flutter/material.dart';
import '../models/house.dart';

class DetalleCasaScreen extends StatefulWidget {
  final House casa;

  const DetalleCasaScreen({Key? key, required this.casa}) : super(key: key);

  @override
  State<DetalleCasaScreen> createState() => _DetalleCasaScreenState();
}

class _DetalleCasaScreenState extends State<DetalleCasaScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.casa.images;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.casa.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrusel de imágenes
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),

            // Indicador del carrusel
            if (images.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    width: currentIndex == index ? 12 : 8,
                    height: currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),

            // Detalles de la casa
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Precio
                  Text(
                    '\$${widget.casa.price}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 10),

                  // Título
                  Text(
                    widget.casa.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  // Descripción
                  Text(
                    widget.casa.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Habitaciones
                  Row(
                    children: [
                      const Icon(Icons.king_bed, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('${widget.casa.bedrooms} habitaciones', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Baños
                  Row(
                    children: [
                      const Icon(Icons.bathtub, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('${widget.casa.bathrooms} baños', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Garaje
                  Row(
                    children: [
                      const Icon(Icons.garage, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('${widget.casa.garage} garaje(s)', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pisos
                  Row(
                    children: [
                      const Icon(Icons.apartment, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('${widget.casa.floors} piso(s)', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),

                 

                  // Fecha de publicación
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Publicado el: ${widget.casa.publishedAt.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}