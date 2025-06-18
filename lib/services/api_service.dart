import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.82:3000/api';
  static const String baseImageUrl = 'http://192.168.1.82:3000';

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

  Future<List<dynamic>> fetchDepartamentosByUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar casas por usuario');
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

  Future<List<dynamic>> fetchAlquileresByUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/alquileres/usuario/$usuarioId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar casas por usuario');
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


}
