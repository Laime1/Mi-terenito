import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/api_service.dart';

class RentalFormScreen extends StatefulWidget {
  final int idUser;
  final int idCity;

  const RentalFormScreen({
    super.key,
    required this.idUser,
    required this.idCity,
  });

  @override
  State<RentalFormScreen> createState() => _RentalFormScreenState();
}

class _RentalFormScreenState extends State<RentalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceMonthController = TextEditingController();
  final TextEditingController _urlMapController = TextEditingController();
  final TextEditingController _timeMinController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  bool _isFurnished = false;
  bool _includesServices = false;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceMonthController.dispose();
    _urlMapController.dispose();
    _timeMinController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 90,
      );

      if (pickedFiles != null) {
        if (_selectedImages.length + pickedFiles.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Máximo 3 imágenes permitidas'))
          );
          return;
        }

        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imágenes: $e'))
      );
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona al menos una imagen'))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final rentalId = await ApiService.createRental(
        title: _titleController.text,
        description: _descriptionController.text,
        monthlyPrice: double.parse(_priceMonthController.text),
        locationLink: _urlMapController.text,
        furnished: _isFurnished ? 'Sí' : 'No',
        minimumMonths: int.parse(_timeMinController.text),
        includedServices: _includesServices ? 'Sí' : 'No',
        userId: widget.idUser,
        cityId: widget.idCity,
        imagePaths: _selectedImages.map((file) => file.path).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alquiler creado exitosamente (ID: $rentalId)'))
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear alquiler: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Alquiler'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Precio Mensual
              TextFormField(
                controller: _priceMonthController,
                decoration: const InputDecoration(
                  labelText: 'Precio Mensual',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio mensual';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Enlace de Ubicación
              TextFormField(
                controller: _urlMapController,
                decoration: const InputDecoration(
                  labelText: 'Enlace de Ubicación (Google Maps)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un enlace de ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Amoblado
              const Text(
                'Amoblado',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isFurnished,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFurnished = value ?? false;
                      });
                    },
                  ),
                  const Text('Sí'),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: _isFurnished,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFurnished = value ?? false;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 16),

              // Campo Tiempo Mínimo en Meses
              TextFormField(
                controller: _timeMinController,
                decoration: const InputDecoration(
                  labelText: 'Tiempo Mínimo (meses)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tiempo mínimo';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Servicios Incluidos
              const Text(
                'Servicios Incluidos',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _includesServices,
                    onChanged: (bool? value) {
                      setState(() {
                        _includesServices = value ?? false;
                      });
                    },
                  ),
                  const Text('Sí'),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: _includesServices,
                    onChanged: (bool? value) {
                      setState(() {
                        _includesServices = value ?? false;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 16),

              // Sección de Imágenes
              const Text(
                'Imágenes (Máximo 3)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Vista previa de imágenes seleccionadas
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              _selectedImages[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // Botón para agregar imágenes
              OutlinedButton.icon(
                onPressed: _selectedImages.length >= 3 ? null : _pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Agregar Imágenes'),
              ),
              const SizedBox(height: 24),

              // Botón de enviar
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar Alquiler',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}