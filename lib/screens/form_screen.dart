import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_terrenito/models/property/property.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/property/location.dart';
import '../services/api_service.dart';

class FormScreen extends  StatefulWidget{
  final int type;
  final int idUser;
  final Property? property;

  const FormScreen({super.key, required this.type, required this.idUser, this.property});

  @override
  State<FormScreen> createState() => _FormScreenState();

}

class _FormScreenState extends State<FormScreen>{

  //controladores
  final TextEditingController _title = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _priceMin = TextEditingController();
  final TextEditingController _priceMax = TextEditingController();

  final TextEditingController _mapLocationController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _mapUrlController = TextEditingController();



  // Variables para el dropdown de ubicación
  List<Location> _ubicaciones = [];
  Location? _selectedUbicacion;
  List<String> _existingImages = [];


  final ApiService _apiService = ApiService();

  // Variables para imágenes
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];


  @override
  void initState() {
    super.initState();
    _fetchUbicaciones().then((_) {
      if (widget.property != null) {
        _loadExistingData();
      }
    });
  }

  void _loadExistingData() {
    final property = widget.property!;
    _title.text = property.name;
    _size.text = property.size.toString();
    _description.text = property.description;
    _priceMin.text = property.minPrice.toString();
    _priceMax.text = property.maxPrice.toString();
    _zoneController.text = property.zone;
    _mapUrlController.text = property.mapLocation ?? '';
    _existingImages = property.images.map((img) => img.url).toList();
    property.location.id = property.idLocation;
    print(property.location.id);

    _selectedUbicacion = _ubicaciones.firstWhere(
          (ubicacion) => ubicacion.id == property.location.id,
      orElse: () => property.location, // Fallback si no se encuentra
    );


  }

  Future<void> _submitForm() async {
    // Validar campos obligatorios
    if (_size.text.isEmpty ||
        _description.text.isEmpty ||
        _priceMin.text.isEmpty ||
        _priceMax.text.isEmpty ||
        _zoneController.text.isEmpty ||
        _selectedUbicacion == null ||
        widget.type == null ||
        (_selectedImages.isEmpty && _existingImages.isEmpty) ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Validar tamaño numérico
    double? tamano = double.tryParse(_size.text);
    double? precioMin = double.tryParse(_priceMin.text);
    double? precioMax = double.tryParse(_priceMax.text);
    if (tamano == null || precioMin == null || precioMax == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tamaño y precios deben ser números válidos')),
      );
      return;
    }

    try {
      int idUsuario = widget.idUser; // Cambiar por el id real del usuario

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if(widget.property == null) {
        // Crear la propiedad
        await _apiService.createProperty(
          _title.text,
          _description.text,
          tamano,
          precioMin,
          precioMax,
          _zoneController.text,
          idUsuario,
          _selectedUbicacion!.id,
          widget.type,
          _selectedImages,
          _mapUrlController.text,
        );
      }else{
        await _apiService.updateProperty(
          widget.property!.id,
          _title.text,
          _description.text,
          tamano,
          precioMin,
          precioMax,
          _zoneController.text,
          _selectedUbicacion!.id,
          widget.type,
          _selectedImages,// Solo las nuevas imágenes seleccionadas
          idUsuario,
          _mapUrlController.text,
        );
      }
      print('Actualizando propiedad con id_tipo: ${widget.type}');


      // Cerrar indicador de carga
      Navigator.of(context).pop();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.property == null
            ? 'Propiedad creada exitosamente'
            : 'Propiedad actualizada exitosamente')),
      );


      // Limpiar formulario
      _clearForm();

      // Opcional: regresar a la pantalla anterior
      // Navigator.of(context).pop();

    } catch (e) {
      // Cerrar indicador de carga si está abierto
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
       print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear propiedad: $e')),
      );
    }
  }

  void _clearForm() {
    _title.clear();
    _size.clear();
    _description.clear();
    _mapUrlController.clear();
    _zoneController.clear();
    setState(() {
      _selectedUbicacion = null;
      _selectedImages.clear();
    });
  }

  void _cancelForm() {
    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar formulario'),
        content: const Text('¿Estás seguro de que deseas cancelar? Se perderán los datos ingresados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Cerrar formulario
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
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





  String _getDisplayText(Location location) {
    return '${location.detailLocation} - ${location.province}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property == null ? 'Registro de Propiedad' : 'Editar Propiedad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelForm,
          ),
        ],
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
            // Mostrar imágenes existentes (solo en edición)
            if (_existingImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _existingImages.length,
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
                              image: NetworkImage(_existingImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 15,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _existingImages.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
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
            Divider(),
            SizedBox(height: 16,),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(gapPadding: 5),
                labelText: 'Título de propiedad',
              ),
              validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _size,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(gapPadding: 5),
                labelText: 'Tamaño de Terreno',
              ),
              validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(gapPadding: 5),
                labelText: 'Descripción',
              ),
              validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: _priceMin,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(gapPadding: 5),
                      labelText: 'Precio minimo',
                    ),
                    validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 5,
                    child:  TextFormField(
                      controller: _priceMax,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(gapPadding: 5),
                        labelText: 'Precio maximo',
                      ),
                      validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                    ),
                )
              ],
            ),

            const SizedBox(height: 16),

            _ubicaciones.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<Location>(
              isExpanded: true,
              value: _ubicaciones.isNotEmpty && _selectedUbicacion != null
                  ? _ubicaciones.firstWhere(
                    (u) => u.id == _selectedUbicacion?.id,
                orElse: () => _selectedUbicacion!,
              )
                  : null,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              hint: Text('Seleccione ubicación'),
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
            SizedBox(height: 16,),
            Row(
              children: [
                // TextFormField para ingresar la URL del mapa
                Expanded(
                  child: TextFormField(
                    controller: _mapUrlController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(gapPadding: 5),
                      labelText: 'Url de mapa',
                    ),
                    validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                  ),
                ),
                const SizedBox(width: 8), // Espacio entre el campo y el botón
                // Botón para abrir Google Maps
                IconButton(
                  onPressed: () async {
                    if (_mapUrlController.text.isEmpty) {
                      // Abrir Google Maps sin ubicación (solo la app)
                      final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps');
                      if (await canLaunchUrl(googleMapsUrl)) {
                        await launchUrl(googleMapsUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se pudo abrir Google Maps')),
                        );
                      }
                    } else {
                      // Abrir la URL específica del mapa
                      final Uri url = Uri.parse(_mapUrlController.text.trim());
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se pudo abrir la URL proporcionada')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.map, color: Colors.blue),
                  tooltip: 'Abrir en Google Maps',
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _zoneController,
              maxLines: 1,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(gapPadding: 5),
                labelText: 'Zona',
              ),
              validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _cancelForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(widget.property == null ? 'Guardar' : 'Actualizar'),                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField formInput({String? title, int? max = 1, TextInputType? type }){
    return TextFormField(
      maxLines: max,
      minLines: 1,
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