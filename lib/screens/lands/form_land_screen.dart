import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mi_terrenito/widgets/utils/url_map_field.dart';
import '../../models/app_fonts.dart';
import '../../models/land.dart';
import '../../services/api_service.dart';

class LandFormScreen extends StatefulWidget {
  final int idUser;
  final int idCity;
  final int idEmpresa;
  final Land? land;

  const LandFormScreen({
    super.key,
    required this.idUser,
    required this.idCity,
    required this.idEmpresa,
    this.land,
  });

  @override
  State<LandFormScreen> createState() => _LandFormScreenState();
}

class _LandFormScreenState extends State<LandFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlMapController = TextEditingController();
  final _sizeController = TextEditingController();
  final _servicesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  List<File> _mobileImages = [];
  List<XFile> _webImages = [];

  List<String> _existingImageUrls = [];
  List<String> _existingImageNames = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.land != null) {
      _titleController.text = widget.land!.title;
      _descriptionController.text = widget.land!.description;
      _priceController.text = widget.land!.price.toString();
      _urlMapController.text = widget.land!.mapLocation;
      _sizeController.text = widget.land!.size.toString();
      _servicesController.text = widget.land!.basicServices;

      _existingImageNames = widget.land!.images ?? [];
      _existingImageUrls =List.from(widget.land!.images);
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked != null) {
      if ((_existingImageUrls.length +
              (kIsWeb ? _webImages.length : _mobileImages.length) +
              picked.length) >
          3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solo se permiten máximo 3 imágenes')),
        );
        return;
      }
      setState(() {
        if (kIsWeb) {
          _webImages.addAll(picked);
        } else {
          _mobileImages.addAll(picked.map((xfile) => File(xfile.path)));
        }
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      if (kIsWeb) {
        _webImages.removeAt(index);
      } else {
        _mobileImages.removeAt(index);
      }
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
      _existingImageNames.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if ((_existingImageUrls.isEmpty &&
            _mobileImages.isEmpty &&
            _webImages.isEmpty) &&
        widget.land == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar al menos una imagen.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success;
      if (widget.land == null) {
        success = await ApiService().crearTerrenoConImagenes(
          titulo: _titleController.text.trim(),
          descripcion: _descriptionController.text.trim(),
          precio: _priceController.text.trim(),
          enlaceUbicacion: _urlMapController.text.trim(),
          tamano: _sizeController.text.trim(),
          serviciosBasicos: _servicesController.text.trim(),
          idUsuario: widget.idUser,
          idCiudad: widget.idCity,
          imagenes: kIsWeb ? null : _mobileImages,
          ximagenes: kIsWeb ? _webImages : null,
        );
      } else {
        success = await ApiService().actualizarTerrenoConImagenes(
          idTerreno: widget.land!.id,
          titulo: _titleController.text.trim(),
          descripcion: _descriptionController.text.trim(),
          precio: _priceController.text.trim(),
          enlaceUbicacion: _urlMapController.text.trim(),
          tamano: _sizeController.text.trim(),
          serviciosBasicos: _servicesController.text.trim(),
          idUsuario: widget.idUser,
          idCiudad: widget.idCity,
          nuevasImagenes: kIsWeb ? null : _mobileImages,
          nuevasXImagenes: kIsWeb ? _webImages : null,
          imagenesExistentes: _existingImageNames,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.land == null
                  ? 'Terreno creado correctamente'
                  : 'Terreno actualizado correctamente')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Error en backend');
      }
    } catch (e) {
      print("Error al guardar terreno: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar terreno')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int? minLines = 1, bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        minLines: minLines,
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Campo requerido' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = _existingImageUrls.length + _mobileImages.length;
    if (totalImages == 0) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        title: Text(widget.land == null ? 'Formulario de Terreno' : 'Actulizar Terreno'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Imágenes (máximo 3)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: totalImages,
                      itemBuilder: (context, index) {
                        Widget imageWidget;
                        bool isExisting = index < _existingImageUrls.length;

                        if (isExisting) {
                          final imageUrl = _existingImageUrls[index];
                          imageWidget = ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              '${ApiService.baseImageUrl}$imageUrl',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) =>
                                  progress == null ? child : const Center(child: CircularProgressIndicator()),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 120),
                            ),
                          );
                        } else {
                          final imageFile = _mobileImages[index - _existingImageUrls.length];
                          imageWidget = ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              imageFile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
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
                                      isExisting ? _removeExistingImage(index) : _removeNewImage(index),
                                ),
                              ),
                            ],
                          ),
                        );

                      }
                      ),
                    ),

                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _mobileImages.length >= 3 ? null : _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Agregar Imágenes'),
                ),

                const SizedBox(height: 24),
                _buildTextField(_titleController, 'Título', Icons.title, maxLines: 3),
                _buildTextField(_descriptionController, 'Descripción', Icons.description, maxLines: 3, minLines: null),
                _buildTextField(_priceController, 'Precio', Icons.attach_money, isNumber: true),
                UrlMapField(controller: _urlMapController),
                const SizedBox(height: 16),
                _buildTextField(_sizeController, 'Tamaño (m²)', Icons.square_foot, isNumber: true),
                _buildTextField(_servicesController, 'Servicios básicos', Icons.plumbing),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.land != null ? 'Actualizar Terreno' : 'Guardar Terreno',
                    style: AppFonts.montserratRegular.copyWith(fontSize: 18),
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
