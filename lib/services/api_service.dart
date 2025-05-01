import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property/property.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.6:8000';

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/properties'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

// Puedes agregar más métodos para POST, PUT, DELETE, etc.
}