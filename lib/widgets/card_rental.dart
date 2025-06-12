import 'package:flutter/material.dart';
import '../models/rent.dart';

class RentalCard extends StatelessWidget {
  final Rental rental;
  final int? idUsuario;

  const RentalCard({super.key, required this.rental, required this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(rental.title ?? 'Sin título'),
        subtitle: Text(rental.description ?? 'Sin descripción'),
        trailing: Text('\$${rental.monthlyPrice ?? '---'} /mes'),
        onTap: () {
          // TODO: Navegar a detalles
        },
      ),
    );
  }
}
