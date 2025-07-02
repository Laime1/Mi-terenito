import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_terrenito/models/apartment.dart';
import 'dart:io';
import 'package:mi_terrenito/widgets/utils/url_map_field.dart';
import '../../services/api_service.dart';

class DepartmentFormScreen extends StatefulWidget {
  final int idUser;
  final int idCity;
  final Apartment? apartment;

  const DepartmentFormScreen({
    super.key,
    required this.idUser,
    required this.idCity,
    this.apartment,
  });

  @override
  State<DepartmentFormScreen> createState() => _DepartmentFormScreenState();
}

class _DepartmentFormScreenState extends State<DepartmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _urlMapController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  List<File> _newImages = [];
  List<String> _existingImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.apartment != null) {
      _titleController.text = widget.apartment!.title;
      _descriptionController.text = widget.apartment!.description;
      _priceController.text = widget.apartment!.price.toString();
      _urlMapController.text = widget.apartment!.mapLocation;
      _roomsController.text = widget.apartment!.bedrooms.toString();
      _bathroomsController.text = widget.apartment!.bathrooms.toString();
      _floorController.text = widget.apartment!.floor.toString();
      _existingImageUrls = List.from(widget.apartment!.images);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _urlMapController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final totalImages = _existingImageUrls.length + _newImages.length;
    if (totalImages >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya has alcanzado el máximo de 3 imágenes.')),
      );
      return;
    }

    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 90,
      );

      if (pickedFiles != null) {
        if (totalImages + pickedFiles.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Puedes agregar un máximo de 3 imágenes en total.')),
          );
          return;
        }
        setState(() {
          _newImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imágenes: $e')),
      );
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_existingImageUrls.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona al menos una imagen')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.apartment != null) {
        await ApiService.updateApartment(
          apartmentId: widget.apartment!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          mapLocation: _urlMapController.text,
          rooms: int.parse(_roomsController.text),
          bathrooms: int.parse(_bathroomsController.text),
          floor: int.parse(_floorController.text),
          cityId: widget.idCity,
          newImageFiles: _newImages,
          existingImageUrls: _existingImageUrls,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Departamento actualizado exitosamente')),
        );
      } else {
        final departmentId = await ApiService.createDepartment(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          locationLink: _urlMapController.text,
          rooms: int.parse(_roomsController.text),
          bathrooms: int.parse(_bathroomsController.text),
          floor: int.parse(_floorController.text),
          userId: widget.idUser,
          cityId: widget.idCity,
          imagePaths: _newImages.map((file) => file.path).toList(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Departamento creado exitosamente (ID: $departmentId)')),
        );
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = _existingImageUrls.length + _newImages.length;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        title: Text(widget.apartment == null ? 'Formulario de Departamento' : 'Editar Departamento', style: TextStyle(color: Colors.white),),
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
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Imágenes (Máximo 3)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (totalImages > 0)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: totalImages,
                      itemBuilder: (context, index) {
                        Widget imageWidget;
                        VoidCallback onRemove;

                        if (index < _existingImageUrls.length) {
                          final imageUrl = _existingImageUrls[index];
                          imageWidget = Image.network(
                            '${ApiService.baseImageUrl}$imageUrl',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) =>
                                progress == null ? child : const Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 40),
                          );
                          onRemove = () => _removeExistingImage(index);
                        } else {
                          final newImageIndex = index - _existingImageUrls.length;
                          imageWidget = Image.file(
                            _newImages[newImageIndex],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                          onRemove = () => _removeNewImage(newImageIndex);
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
                                  onPressed: onRemove,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                OutlinedButton.icon(
                  onPressed: totalImages >= 3 ? null : _pickImages,
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
                  validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa un título' : null,
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
                  validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa una descripción' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                    prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty || double.tryParse(value) == null ? 'Ingresa un precio válido' : null,
                ),
                const SizedBox(height: 16),
                UrlMapField(controller: _urlMapController),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _roomsController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Habitaciones',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.king_bed, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty || int.tryParse(value) == null ? 'Ingresa un número válido' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _bathroomsController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Baños',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bathtub, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty || int.tryParse(value) == null ? 'Ingresa un número válido' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _floorController,
                  decoration: const InputDecoration(
                    labelText: 'Piso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.stairs, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty || int.tryParse(value) == null ? 'Ingresa un número válido' : null,
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
                  child: Text(
                    widget.apartment == null ? 'Guardar Departamento' : 'Actualizar Departamento',
                    style: const TextStyle(fontSize: 18),
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
