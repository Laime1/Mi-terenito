import 'dart:convert';
import 'package:http/http.dart' as http;
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
}