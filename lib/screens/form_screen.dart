import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/property/location.dart';
import '../services/api_service.dart';
import '../widgets/map_selection.dart';

class FormScreen extends  StatefulWidget{
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();

}

class _FormScreenState extends State<FormScreen>{

  //controladores
  final TextEditingController _title = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _mapLocationController = TextEditingController();


  // Variables para Google Maps
  String _selectedAddress = '';
  LatLng? _selectedLocation;

  // Variables para el dropdown de ubicación
  List<Location> _ubicaciones = [];
  Location? _selectedUbicacion;
  final ApiService _apiService = ApiService();

  // Variables para imágenes
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];


  @override
  void initState() {
    super.initState();
    _fetchUbicaciones();
  }

  Future<void> _fetchUbicaciones() async {
    try {
      final ubicaciones = await _apiService.fetchUbicaciones();
      setState(() {
        _ubicaciones = ubicaciones;
      });
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ubicaciones: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        if (_selectedImages.length >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Máximo 3 imágenes permitidas')),
          );
          return;
        }
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _openGoogleMaps() async {
    // Aquí podrías abrir un diálogo o nueva pantalla con el mapa
    // Por ahora simularemos la selección de una ubicación
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const MapSelectionDialog(),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result['location'];
        _selectedAddress = result['address'];
        _mapLocationController.text = _selectedAddress;
      });
    }
  }

  Future<void> _openInGoogleMaps() async {
    if (_selectedLocation != null) {
      final url =
          'https://www.google.com/maps/search/?api=1&query=${_selectedLocation!.latitude},${_selectedLocation!.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Google Maps')),
        );
      }
    }
  }


  String _getDisplayText(Location location) {
    return '${location.detailLocation} - ${location.province}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Registro de Propiedad'),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(32),
        child: Column(
          children: [
            // Sección de imágenes
            Text(
              'Imágenes de la propiedad (Máx. 3)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            // Mostrar imágenes seleccionadas
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 15,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => _removeImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            // Botones para agregar imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1),
            formInput( title: 'Titulo de propiedad', type: TextInputType.name),
            SizedBox(height: 16,),
            formInput(title: 'Tamaño de Terreno',),
            SizedBox(height: 16,),
            formInput(title: 'Descripcion', max: 3),
            SizedBox(height: 16,),
            _ubicaciones.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<Location>(
              isExpanded: true,
              value: _selectedUbicacion,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              hint: const Text('Seleccione ubicación'),
              items: _ubicaciones.map((ubicacion) {
                return DropdownMenuItem<Location>(
                  value: ubicacion,
                  child: Text(
                    _getDisplayText(ubicacion),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (Location? value) {
                setState(() {
                  _selectedUbicacion = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor seleccione una ubicación';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            formInput(title: 'Zona'),
            const SizedBox(height: 16),
            const Text(
              'Ubicación en Mapa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _mapLocationController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Dirección seleccionada',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.map),
                        onPressed: _openGoogleMaps,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedLocation != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Ver en Google Maps'),
                onPressed: _openInGoogleMaps,
              ),

          ],
        ),
      ),
    );
  }

  TextFormField formInput({String? title, int? max = 1, TextInputType? type }){
    return TextFormField(
      maxLines: max,
      keyboardType: type,
      decoration:  InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border:  OutlineInputBorder(
          gapPadding: 5,
        ),
        labelText: title,
      ),
    );
  }

}