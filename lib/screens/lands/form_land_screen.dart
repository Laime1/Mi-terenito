import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mi_terrenito/widgets/utils/url_map_field.dart';
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
      {int lines = 1, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: lines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.land == null ? 'Agregar Terreno' : 'Editar Terreno'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Imágenes (máximo 3)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              if (_existingImageUrls.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _existingImageUrls.length,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            '${ApiService.baseImageUrl}${_existingImageUrls[index]}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeExistingImage(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (kIsWeb && _webImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _webImages.length,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Image.network(
                          _webImages[index].path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeNewImage(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (!kIsWeb && _mobileImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mobileImages.length,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Image.file(
                          _mobileImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeNewImage(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if ((_existingImageUrls.length +
                            (kIsWeb ? _webImages.length : _mobileImages.length)) >=
                        3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solo se permiten máximo 3 imágenes')),
                      );
                      return;
                    }
                    _pickImage();
                  },
                  icon: const Icon(Icons.image),
                  label: Text(kIsWeb ? 'Seleccionar imágenes' : 'Agregar imágenes'),
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildTextField(_titleController, 'Título', Icons.title),
              _buildTextField(_descriptionController, 'Descripción', Icons.description, lines: 3),
              _buildTextField(_priceController, 'Precio', Icons.attach_money, isNumber: true),
              UrlMapField(controller: _urlMapController),
              const SizedBox(height: 16),
              _buildTextField(_sizeController, 'Tamaño (m²)', Icons.square_foot, isNumber: true),
              _buildTextField(_servicesController, 'Servicios básicos', Icons.plumbing),

              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.land == null ? 'Guardar Terreno' : 'Actualizar Terreno',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
