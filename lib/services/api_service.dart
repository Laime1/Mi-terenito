import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';
  static const String baseImageUrl = 'http://localhost:3000';

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
}
