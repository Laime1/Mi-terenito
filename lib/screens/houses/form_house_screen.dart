import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mi_terrenito/models/app_fonts.dart';
import 'package:mime_type/mime_type.dart';
import '../../models/house.dart';
import '../../services/api_service.dart';
import 'package:mi_terrenito/models/app_colors.dart';

class FormHouseScreen extends StatefulWidget {
  final int idUsuario;
  final int idCiudad;
  final House? house;

  const FormHouseScreen({
    Key? key,
    required this.idUsuario,
    required this.idCiudad,
    this.house,
  }) : super(key: key);

  @override
  State<FormHouseScreen> createState() => _FormHouseScreenState();
}

class _FormHouseScreenState extends State<FormHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _ubicacionController;
  late TextEditingController _habitacionesController;
  late TextEditingController _banosController;
  late TextEditingController _cocheraController;
  late TextEditingController _pisosController;

  List<String> _imagenesExistentesUrls = [];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.house?.title ?? '');
    _descripcionController = TextEditingController(text: widget.house?.description ?? '');
    _precioController = TextEditingController(text: widget.house?.price.toString() ?? '');
    _ubicacionController = TextEditingController(text: widget.house?.mapLocation ?? '');
    _habitacionesController = TextEditingController(text: widget.house?.bedrooms.toString() ?? '');
    _banosController = TextEditingController(text: widget.house?.bathrooms.toString() ?? '');
    _cocheraController = TextEditingController(text: widget.house?.garage.toString() ?? '');
    _pisosController = TextEditingController(text: widget.house?.floors.toString() ?? '');

    _imagenesExistentesUrls = widget.house?.images
            .map((img) => '${ApiService.baseImageUrl}$img')
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _ubicacionController.dispose();
    _habitacionesController.dispose();
    _banosController.dispose();
    _cocheraController.dispose();
    _pisosController.dispose();
    super.dispose();
  }
Future<void> _pickFromGallery() async {
  final List<XFile>? selectedImages = await _picker.pickMultiImage();
  if (selectedImages != null && selectedImages.isNotEmpty) {
    setState(() {
      for (var image in selectedImages) {
        if (_images.length + _imagenesExistentesUrls.length < 3 &&
            !_images.any((img) => img.path == image.path)) {
          _images.add(image);
        }
      }
    });
  }
}

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imagenesExistentesUrls.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagenesExistentesUrls.length,
              itemBuilder: (context, index) {
                final url = _imagenesExistentesUrls[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.navigationButtonBackground),
                          onPressed: () {
                            setState(() {
                              _imagenesExistentesUrls.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        if (_imagenesExistentesUrls.isNotEmpty && _images.isNotEmpty)
          const SizedBox(height: 12),
        if (_images.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final imageFile = File(_images[index].path);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          imageFile,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.navigationButtonBackground),
                          onPressed: () => _removeImage(index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> guardarCasa() async {
  if (!_formKey.currentState!.validate()) return;

  if (_images.isEmpty && _imagenesExistentesUrls.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debes agregar al menos una imagen')),
    );
    return;
  }

  try {
    final titulo = _tituloController.text;
    final descripcion = _descripcionController.text;
    final precio = _precioController.text;
    final ubicacion = _ubicacionController.text;
    final habitaciones = _habitacionesController.text;
    final banos = _banosController.text;
    final garage = _cocheraController.text;
    final pisos = _pisosController.text;

    if (widget.house != null) {
      final List<String> imagenesOriginales = widget.house!.images
          .map((img) => '${ApiService.baseImageUrl}$img')
          .toList();

      final List<String> imagenesEliminadas = imagenesOriginales
          .where((url) => !_imagenesExistentesUrls.contains(url))
          .toList();

      for (String url in imagenesEliminadas) {
        final fileName = Uri.parse(url).pathSegments.last;
        await ApiService().eliminarImagenDeCasa(fileName);
      }

      final exito = await ApiService().actualizarCasaConImagenes(
        idCasa: widget.house!.id,
        titulo: titulo,
        descripcion: descripcion,
        precio: precio,
        enlaceUbicacion: ubicacion,
        habitaciones: habitaciones,
        banos: banos,
        cochera: garage,
        pisos: pisos,
        idUsuario: widget.idUsuario,
        idCiudad: widget.idCiudad,
        nuevasImagenes: _images.map((xfile) => File(xfile.path)).toList(),
      );

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa actualizada correctamente')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la casa')),
        );
      }
    } else {

      final exito = await ApiService().crearCasaConImagenes(
        titulo: titulo,
        descripcion: descripcion,
        precio: precio,
        enlaceUbicacion: ubicacion,
        habitaciones: habitaciones,
        banos: banos,
        cochera: garage,
        pisos: pisos,
        idUsuario: widget.idUsuario,
        idCiudad: widget.idCiudad,
        imagenes: _images.map((xfile) => File(xfile.path)).toList(),
      );

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa creada correctamente')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear la casa')),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackground,
      appBar: AppBar(
        titleTextStyle: AppFonts.montserratBold.copyWith(fontSize: 18, color: AppColors.appBarText),
        title: Text(widget.house != null ? 'Editar Casa' : 'Formulario de Casa'),
        backgroundColor: AppColors.navigationButtonBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: AppFonts.montserratRegular.copyWith(fontSize: 14),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Imágenes (Máximo 3)', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                _buildImageGallery(),
                OutlinedButton.icon(
                  onPressed: (_images.length + _imagenesExistentesUrls.length) >= 3 ? null: _pickFromGallery,

                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Agregar desde galería'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese un título' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese una descripción' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(labelText: 'Precio', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null || double.tryParse(value) == null
                      ? 'Ingrese un precio válido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ubicacionController,
                  decoration: const InputDecoration(labelText: 'Ubicación (link de mapa)', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Ingrese una ubicación' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _habitacionesController,
                        decoration: const InputDecoration(labelText: 'Habitaciones', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || int.tryParse(value) == null ? 'Número inválido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _banosController,
                        decoration: const InputDecoration(labelText: 'Baños', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || int.tryParse(value) == null ? 'Número inválido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('¿Tiene cochera?',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black), // Recuadro negro
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: _cocheraController.text == 'true',
                                    onChanged: (value) {
                                      setState(() =>
                                          _cocheraController.text = value.toString());
                                    },
                                  ),
                                  const Text('Sí'),
                                  const SizedBox(width: 20),
                                  Radio<bool>(
                                    value: false,
                                    groupValue: _cocheraController.text == 'true',
                                    onChanged: (value) {
                                      setState(() =>
                                          _cocheraController.text = value.toString());
                                    },
                                  ),
                                  const Text('No'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _pisosController,
                          decoration: const InputDecoration(
                            labelText: 'Pisos',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || int.tryParse(value) == null
                                  ? 'Número inválido'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: guardarCasa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navigationButtonBackground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.house != null ? 'Actualizar Casa' : 'Guardar Casa',
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
