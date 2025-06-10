import 'package:flutter/material.dart';

class EmpresaCard extends StatelessWidget {
  final Map<String, dynamic> empresa;
  final bool isSelected;
  final VoidCallback onSelect;

  const EmpresaCard({
    Key? key,
    required this.empresa,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue[100] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            empresa['nombre'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: ${empresa['descripcion']}', style: const TextStyle(fontSize: 12)),
              Text('Contacto: ${empresa['contacto']}', style: const TextStyle(fontSize: 12)),
              Text('Correo: ${empresa['correo']}', style: const TextStyle(fontSize: 12)),
            ],
          ),
          trailing: SizedBox(
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: onSelect,
              child: const Text('Seleccionar'),
            ),
          ),
        ),
      ),
    );
  }
}