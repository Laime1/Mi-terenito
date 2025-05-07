import 'package:flutter/material.dart';

import '../models/property/location.dart';
import '../services/api_service.dart';

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

  // Variables para el dropdown de ubicación
  List<Location> _ubicaciones = [];
  Location? _selectedUbicacion;
  final ApiService _apiService = ApiService();

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