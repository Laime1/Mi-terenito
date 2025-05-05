import 'package:flutter/material.dart';

class HousesScreen extends StatelessWidget {
  const HousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casas'),
        backgroundColor: Colors.blue[700],
      ),
      body: const Center(
        child: Text(
          'Listado de casas',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
