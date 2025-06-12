import 'package:flutter/material.dart';
import '../../models/rent.dart'; // Asegúrate de que esta ruta sea correcta

class RentalCard extends StatelessWidget {
  final Rental rental;
  final int? idUsuario;

  const RentalCard({super.key, required this.rental, this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(rental.title ?? 'Sin título'),
        subtitle: Text(rental.description ?? 'Sin descripción'),
        trailing: Text('S/. ${rental.monthlyPrice ?? 0}'),
        onTap: () {
          // Aquí puedes navegar a una pantalla de detalles si la tienes
        },
      ),
    );
  }
}
