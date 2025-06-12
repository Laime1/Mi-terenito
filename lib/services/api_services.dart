import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_terrenito/models/house.dart';

import '../models/Rent.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.10:8000/api';

  // Obtener casas filtradas por empresa y ciudad
  static Future<List<House>> getHousesByCompanyAndCity({
    required int companyId,
    required int cityId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/casas/empresa/$companyId/ciudad/$cityId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => House.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load houses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load houses: $e');
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

}