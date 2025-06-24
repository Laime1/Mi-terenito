import 'package:flutter/material.dart';

class FormLandScreen extends StatelessWidget {
  final int idUsuario;
  final int idCiudad;

  const FormLandScreen({
    super.key,
    required this.idUsuario,
    required this.idCiudad,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar terreno')),
      body: const Center(
        child: Text('Formulario de terreno aquí'),
      ),
    );
  }
}
