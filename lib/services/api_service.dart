import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property/location.dart';
import '../models/property/property.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

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

  Future<void> deleteProperty(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/propiedades/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la propiedad');
    }
  }

  // Aquí está el método nuevo que pediste:
  Future<Map<String, dynamic>> getUserById(int idUsuario) async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios/$idUsuario'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener información del usuario');
    }
  }
}
