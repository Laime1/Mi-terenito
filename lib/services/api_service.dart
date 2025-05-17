import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/property/location.dart';
import '../models/property/property.dart';

class ApiService {
  static const String baseUrl = 'https://api-terrenito-nodejs.onrender.com/api';

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/propiedades'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<List<Property>> fetchPropertiesByUserId(int idUsuario) async {
    final response = await http.get(Uri.parse('$baseUrl/propiedades/usuario/$idUsuario'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener propiedades del usuario');
    }
  }

  Future<List<Location>> fetchUbicaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/ubicaciones'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map<Location>((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ubicaciones');
    }
  }

  // En tu ApiService, agrega este método:
  Future<Property> createProperty(
      String titulo,
      String descripcion,
      double tamano,
      double precioMin,
      double precioMax,
      String zona,
      int idUsuario,
      int idUbicacion,
      int idTipo,
      List<File> imagenes,
      String urlMap,
      ) async {
    // Crear la solicitud multipart
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/propiedades')
    );

    // Agregar campos de texto (deben coincidir exactamente con los que espera el backend)
    request.fields['titulo'] = titulo;
    request.fields['descripcion'] = descripcion;
    request.fields['tamano'] = tamano.toString();
    request.fields['precio_min'] = precioMin.toString();
    request.fields['precio_max'] = precioMax.toString();
    request.fields['zona'] = zona;
    request.fields['id_usuario'] = idUsuario.toString();
    request.fields['id_ubicacion'] = idUbicacion.toString();
    request.fields['id_tipo'] = idTipo.toString();
    request.fields['Enlace_ubicacion'] = urlMap;


    // Agregar imágenes (el nombre 'imagenes' debe coincidir con upload.array('imagenes'))
    for (var image in imagenes) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'imagenes', // Este nombre debe coincidir exactamente
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return Property.fromJson(json.decode(responseString));
      } else {
        throw Exception('Error ${response.statusCode}: $responseString');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  Future<Property> updateProperty(
      int idPropiedad,
      String titulo,
      String descripcion,
      double tamano,
      double precioMin,
      double precioMax,
      String zona,
      int idUbicacion,
      int idTipo,
      List<File> nuevasImagenes,
      int idUsuario,
      String urlMap,
      ) async {
    var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/propiedades/$idPropiedad')
    );

    // Campos de texto (deben coincidir exactamente con los nombres que espera el backend)
    request.fields['titulo'] = titulo;
    request.fields['descripcion'] = descripcion;
    request.fields['tamano'] = tamano.toString();
    request.fields['precio_min'] = precioMin.toString();
    request.fields['precio_max'] = precioMax.toString();
    request.fields['zona'] = zona;
    request.fields['id_usuario'] = idUsuario.toString(); // Asume que tienes acceso al idUsuario
    request.fields['id_ubicacion'] = idUbicacion.toString();
    request.fields['id_tipo'] = idTipo.toString();
    request.fields['Enlace_ubicacion'] = urlMap;


    // Agregar nuevas imágenes (el nombre 'imagenes' debe coincidir con upload.array('imagenes'))
    for (var image in nuevasImagenes) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'imagenes', // ¡Este nombre debe coincidir exactamente!
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Property.fromJson(json.decode(responseString));
      } else {
        throw Exception('Error typo: $idTipo ${response.statusCode}: $responseString');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  Future<void> deleteProperty(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/propiedades/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la propiedad');
    }
  }

}