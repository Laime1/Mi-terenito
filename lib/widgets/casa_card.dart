import 'package:flutter/material.dart';
import '../models/house.dart';
import '../screens/houses/details_house_screen.dart';

class CasaCard extends StatelessWidget {
  final House house;

  const CasaCard({Key? key, required this.house}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsHouseScreen(casa: house),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              house.images.isNotEmpty ? house.images[0] : 'https://via.placeholder.com/300',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                house.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Precio: \$${house.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
