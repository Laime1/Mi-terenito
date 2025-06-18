import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class FormHouseScreen extends StatefulWidget {
  final int idUsuario;
  final int idCiudad;

  const FormHouseScreen({
    Key? key,
    required this.idUsuario,
    required this.idCiudad,
  }) : super(key: key);

  @override
  State<FormHouseScreen> createState() => _FormHouseScreenState();
}

class _FormHouseScreenState extends State<FormHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  String? titulo;
  String? descripcion;
  double? precio;
  String? ubicacion;
  int? habitaciones;
  int? banos;
  int? cochera;
  int? pisos;

  Future<void> _pickFromGallery() async {
    if (_images.length >= 3) return;

    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        for (var image in selectedImages) {
          if (_images.length < 3 && !_images.any((img) => img.path == image.path)) {
            _images.add(image);
          }
        }
      });
    }
  }

  Future<void> _pickFromCamera() async {
    if (_images.length >= 3) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        if (_images.length < 3) {
          _images.add(photo);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> guardarCasa() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos una imagen')),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      final imagenes = _images.map((xfile) => File(xfile.path)).toList();

      await ApiService().crearCasaConImagenes(
        titulo: titulo!,
        descripcion: descripcion!,
        precio: precio!.toString(),
        enlaceUbicacion: ubicacion!,
        habitaciones: habitaciones!.toString(),
        banos: banos!.toString(),
        cochera: cochera!.toString(),
        pisos: pisos!.toString(),
        idUsuario: widget.idUsuario,
        idCiudad: widget.idCiudad,
        imagenes: imagenes,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Casa guardada correctamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Casa'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Imágenes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length < 3 ? _images.length + 1 : _images.length,
                  itemBuilder: (context, index) {
                    if (index == _images.length && _images.length < 3) {
                      return PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'camera') {
                            _pickFromCamera();
                          } else if (value == 'gallery') {
                            _pickFromGallery();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'camera',
                            child: Text('Tomar foto'),
                          ),
                          const PopupMenuItem(
                            value: 'gallery',
                            child: Text('Desde galería'),
                          ),
                        ],
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(Icons.add_a_photo, size: 60, color: Colors.black54),
                          ),
                        ),
                      );
                    }

                    final imageFile = File(_images[index].path);
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(imageFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => titulo = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingrese un título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => descripcion = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingrese una descripción' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Precio',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => precio = double.tryParse(value ?? ''),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Ingrese un precio válido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => ubicacion = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingrese una ubicación' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Habitaciones',
                        prefixIcon: const Icon(Icons.king_bed),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => habitaciones = int.tryParse(value ?? ''),
                      validator: (value) => value == null || int.tryParse(value) == null ? 'Ingrese un número válido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Baños',
                        prefixIcon: const Icon(Icons.bathtub),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => banos = int.tryParse(value ?? ''),
                      validator: (value) => value == null || int.tryParse(value) == null ? 'Ingrese un número válido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cochera',
                        prefixIcon: const Icon(Icons.directions_car),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => cochera = int.tryParse(value ?? ''),
                      validator: (value) => value == null || int.tryParse(value) == null ? 'Ingrese un número válido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Pisos',
                        prefixIcon: const Icon(Icons.layers),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => pisos = int.tryParse(value ?? ''),
                      validator: (value) => value == null || int.tryParse(value) == null ? 'Ingrese un número válido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: guardarCasa,
                      child: const Text('Guardar', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
