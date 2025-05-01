// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property/property.dart';

class ApiService {
  // ✅ IP de tu servidor Laravel en red local
  static const String host = 'https://api-terrenito.onrender.com';
  static const String baseUrl = '$host/api';

  static String get hostUrl => host;

  Future<List<Property>> fetchProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/propiedades'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }
}
