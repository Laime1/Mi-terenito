import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Rent.dart';
import '../models/apartament.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.10:3000/api';

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
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar terrenos');
    }
  }

  Future<List<dynamic>> fetchDepartamentosByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  Future<List<dynamic>> fetchAlquileresByEmpresaAndCiudad(int empresaId, int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/alquileres/empresa/$empresaId/ciudad/$cityId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar alquileres');
    }
  }
}
