import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property/location.dart';
import '../models/property/property.dart';

class ApiService {
  static const String baseUrl = 'https://api-terrenito.onrender.com/api';

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/propiedades'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
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
// Puedes agregar más métodos para POST, PUT, DELETE, etc.
}