
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectionDialog extends StatefulWidget {
  const MapSelectionDialog({super.key});

  @override
  State<MapSelectionDialog> createState() => _MapSelectionDialogState();
}

class _MapSelectionDialogState extends State<MapSelectionDialog> {
  late GoogleMapController _mapController;
  LatLng? _selectedPosition;
  String _selectedAddress = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccione una ubicación'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-17.3895, -66.1568), // Coordenadas de Cochabamba
                  zoom: 12,
                ),
                onMapCreated: (controller) => _mapController = controller,
                onTap: (LatLng position) async {
                  _selectedPosition = position;
                  final addresses = await placemarkFromCoordinates(
                    position.latitude,
                    position.longitude,
                  );
                  if (addresses.isNotEmpty) {
                    final place = addresses.first;
                    setState(() {
                      _selectedAddress =
                      '${place.street}, ${place.locality}, ${place.country}';
                    });
                  }
                },
                markers: _selectedPosition == null
                    ? {}
                    : {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _selectedPosition!,
                  ),
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(_selectedAddress),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _selectedPosition == null
              ? null
              : () => Navigator.pop(context, {
            'location': _selectedPosition,
            'address': _selectedAddress,
          }),
          child: const Text('Seleccionar'),
        ),
      ],
    );
  }
}