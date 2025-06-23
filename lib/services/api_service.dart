import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import '../models/rental.dart';
import '../models/apartment.dart';

class ApiService {
  // static const String baseUrl = 'https://api-nodejs-7tvl.onrender.com/api';
  static const String baseUrl = 'http://192.168.0.10:3000/api';
  // static const String baseImageUrl = 'https://api-nodejs-7tvl.onrender.com';
  static const String baseImageUrl = 'http://192.168.0.10:3000';


  static Future<List<Apartment>> getApartmentsByCompanyAndCity({
    required int companyId,
    required int cityId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/departamentos/empresa/$companyId/ciudad/$cityId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Apartment.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar departamentos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Rental>> getRentalsByCompanyAndCity({
    required int companyId,
    required int cityId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alquileres/empresa/$companyId/ciudad/$cityId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Rental.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load rentals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load rentals: $e');
    }
  }

  Future<List<String>> fetchCities() async {
    final response = await http.get(Uri.parse('$baseUrl/ciudades'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data.map((city) => city['nombre']));
    } else {
      throw Exception('Error al cargar ciudades');
    }
  }

  Future<int> getCityIdByName(String cityName) async {
    final response = await http.get(Uri.parse('$baseUrl/ciudades'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final city = data.firstWhere((c) => c['nombre'] == cityName, orElse: () => null);
      if (city != null) {
        return city['id_ciudad'];
      } else {
        throw Exception('Ciudad no encontrada');
      }
    } else {
      throw Exception('Error al cargar ciudades');
    }
  }

  Future<List<dynamic>> fetchEmpresasByCiudad(int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/empresas/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar empresas');
    }
  }

  Future<List<dynamic>> fetchCasasByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/casas/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar casas');
    }
  }

  Future<List<dynamic>> fetchTerrenosByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/terrenos/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar terrenos');
    }
  }

  Future<List<dynamic>> fetchDepartamentosByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  Future<List<dynamic>> fetchAlquileresByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/alquileres/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar alquileres');
    }
  }

  Future<bool> existePropiedad(String tipo, int idEmpresa, int idCiudad) async {
    final url = Uri.parse('$baseUrl/$tipo/empresa/$idEmpresa/ciudad/$idCiudad');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is List && data.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> fetchCasasByUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/casas/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar casas por usuario');
    }
  }

 static Future<List<Apartment>> fetchDepartamentosByUsuario(int userId) async {
   try {
     final response = await http.get(
       Uri.parse('$baseUrl/departamentos/usuario/$userId'),
     );

     if (response.statusCode == 200) {
       final List<dynamic> data = json.decode(response.body);
       return data.map((json) => Apartment.fromJson(json)).toList();
     } else {
       throw Exception('Error al cargar departamentos: ${response.statusCode}');
     }
   } catch (e) {
     throw Exception('Error de conexión: $e');
   }
 }


  static Future<int> createRental({
    required String title,
    required String description,
    required double monthlyPrice,
    required String locationLink,
    required String furnished,
    required int minimumMonths,
    required String includedServices,
    required int userId,
    required int cityId,
    required List<String> imagePaths,
  }) async {
    try {
      // Crear la solicitud multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/alquileres'),
      );

      // Agregar campos de texto
      request.fields['titulo'] = title;
      request.fields['descripcion'] = description;
      request.fields['precio_mensual'] = monthlyPrice.toString();
      request.fields['enlace_ubicacion'] = locationLink;
      request.fields['amoblado'] = furnished;
      request.fields['tiempo_minimo_meses'] = minimumMonths.toString();
      request.fields['incluye_servicios'] = includedServices;
      request.fields['id_usuario'] = userId.toString();
      request.fields['id_ciudad'] = cityId.toString();

      // Agregar imágenes
      for (var imagePath in imagePaths) {
        var mimeType = mime(imagePath)?.split('/');
        if (mimeType != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'imagenes',
            imagePath,
            contentType: MediaType(mimeType[0], mimeType[1]),
          ));
        }
      }

      // Enviar la solicitud
      var response = await request.send();

      // Procesar la respuesta
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['id_alquiler'] as int;
      } else {
        final errorMessage = await response.stream.bytesToString();
        throw Exception('Error al crear alquiler: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<dynamic>> fetchTerrenosByUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/terrenos/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar casas por usuario');
    }
  }

  static Future<List<Rental>> fetchAlquileresByUsuario(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alquileres/usuario/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Rental.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar alquileres: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> crearCasaConImagenes({
  required String titulo,
  required String descripcion,
  required String precio,
  required String enlaceUbicacion,
  required String habitaciones,
  required String banos,
  required String cochera,
  required String pisos,
  required int idUsuario,
  required int idCiudad,
  required List<File> imagenes,
}) async {
  var uri = Uri.parse('$baseUrl/casas');
  var request = http.MultipartRequest('POST', uri);
  request.fields['titulo'] = titulo;
  request.fields['descripcion'] = descripcion;
  request.fields['precio'] = precio;
  request.fields['enlace_ubicacion'] = enlaceUbicacion;
  request.fields['habitaciones'] = habitaciones;
  request.fields['banos'] = banos;
  request.fields['cochera'] = cochera;
  request.fields['pisos'] = pisos;
  request.fields['id_usuario'] = idUsuario.toString();
  request.fields['id_ciudad'] = idCiudad.toString();

  for (var imagen in imagenes) {
    final fileName = imagen.path.split('/').last;
    request.files.add(
      await http.MultipartFile.fromPath('imagenes', imagen.path, filename: fileName),
    );
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode == 201 || response.statusCode == 200) {
    print("Casa creada correctamente: $responseBody");
    return true;
  } else {
    print("Error al crear casa: ${response.statusCode}");
    print(responseBody);
    return false;
  }
  }



  static Future<int> createDepartment({
    required String title,
    required String description,
    required double price,
    required String locationLink,
    required int rooms,
    required int bathrooms,
    required int floor,
    required int userId,
    required int cityId,
    required List<String> imagePaths,
  }) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/departamentos')
      );
      // Agregar campos de texto
      request.fields['titulo'] = title;
      request.fields['descripcion'] = description;
      request.fields['precio'] = price.toString();
      request.fields['enlace_ubicacion'] = locationLink;
      request.fields['habitaciones'] = rooms.toString();
      request.fields['banos'] = bathrooms.toString();
      request.fields['piso'] = floor.toString();
      request.fields['id_usuario'] = userId.toString();
      request.fields['id_ciudad'] = cityId.toString();

      // Agregar imágenes
      for (var imagePath in imagePaths) {
        var mimeType = mime(imagePath)?.split('/');
        if (mimeType != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'imagenes',
            imagePath,
            contentType: MediaType(mimeType[0], mimeType[1]),
          ));
        }
      }
      var response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['id_departamento'] as int;
      } else {
        final errorMessage = await response.stream.bytesToString();
        throw Exception('Error al crear departamento: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
