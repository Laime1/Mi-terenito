import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/rental.dart';
import '../../services/api_service.dart';
import 'package:mi_terrenito/widgets/utils/url_map_field.dart';

class RentalFormScreen extends StatefulWidget {
  final int idUser;
  final int idCity;
  final Rental? rental;

  const RentalFormScreen({
    super.key,
    required this.idUser,
    required this.idCity,
    this.rental,
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
  List<String> _existingImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.rental != null) {
      final rental = widget.rental!;
      _titleController.text = rental.title;
      _descriptionController.text = rental.description;
      _priceMonthController.text = rental.monthlyPrice.toString();
      _urlMapController.text = rental.mapLocation;
      _timeMinController.text = rental.minimumMonths.toString();
      _isFurnished = rental.furnished == 'Sí';
      _includesServices = rental.includedServices == 'Sí';
      _existingImageUrls = rental.images;
    }
  }

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
              const SnackBar(content: Text('Máximo 3 imágenes permitidas')));
          return;
        }

        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imágenes: $e')));
    }
  }

  Future<void> _removeImage(int index, bool isExisting) async {
    setState(() {
      if (isExisting) {
        _existingImageUrls.removeAt(index);
      } else {
        _selectedImages.removeAt(index);
      }
    });
  }

  Widget _buildImagePreviews() {
    final totalImages = _existingImageUrls.length + _selectedImages.length;
    if (totalImages == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalImages,
        itemBuilder: (context, index) {
          Widget imageWidget;
          bool isExisting = index < _existingImageUrls.length;

          if (isExisting) {
            final imageUrl = _existingImageUrls[index];
            imageWidget = Image.network(
              '${ApiService.baseImageUrl}$imageUrl',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            );
          } else {
            final imageFile = _selectedImages[index - _existingImageUrls.length];
            imageWidget = Image.file(
              imageFile,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                imageWidget,
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () =>
                        _removeImage(isExisting ? index : index - _existingImageUrls.length, isExisting),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty && _existingImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona al menos una imagen')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.rental != null) {
        await ApiService.updateRental(
          rentalId: widget.rental!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          monthlyPrice: double.parse(_priceMonthController.text),
          locationLink: _urlMapController.text,
          furnished: _isFurnished ? 'Sí' : 'No',
          minimumMonths: int.parse(_timeMinController.text),
          includedServices: _includesServices ? 'Sí' : 'No',
          cityId: widget.idCity,
          newImageFiles: _selectedImages,
          existingImageUrls: _existingImageUrls,
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alquiler actualizado exitosamente')));
      } else {
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
            SnackBar(content: Text('Alquiler creado exitosamente (ID: $rentalId)')));
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el alquiler: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rental == null ? 'Formulario de Alquiler' : 'Editar Alquiler',
          style: const TextStyle(color: Colors.white),
        ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Imágenes (Máximo 3)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildImagePreviews(),
                OutlinedButton.icon(
                  onPressed: _selectedImages.length >= 3 ? null : _pickImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Agregar Imágenes'),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title, color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description, color: Colors.green),
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
                TextFormField(
                  controller: _priceMonthController,
                  decoration: const InputDecoration(
                    labelText: 'Precio Mensual',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.green),
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
                UrlMapField(controller: _urlMapController),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeMinController,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo Mínimo (meses)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer, color: Colors.green),
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
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      ),
    );
  }
}
