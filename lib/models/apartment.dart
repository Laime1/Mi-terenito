import 'package:mi_terrenito/models/city.dart';
import 'package:mi_terrenito/models/company.dart';
import 'package:mi_terrenito/models/user.dart';

class Apartment {
  final int id;
  final String title;
  final String description;
  final double price;
  final int status;
  final DateTime publishedAt;
  final String mapLocation;
  final int bedrooms;
  final int bathrooms;
  final int floor;
  final List<String> images;
  final User? user;
  final City? city;
  final Company? company;

  Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.publishedAt,
    required this.mapLocation,
    required this.bedrooms,
    required this.bathrooms,
    required this.floor,
    required this.images,
    required this.user,
    required this.city,
    required this.company,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: _parseInt(json['id_departamento']),
      title: json['titulo']?.toString() ?? '',
      description: json['descripcion']?.toString() ?? '',
      price: _parseDouble(json['precio']) ?? 0,
      status: _parseInt(json['estado']) ?? 1,
      publishedAt: _parseDateTime(json['fecha_publicacion']),
      mapLocation: json['enlace_ubicacion']?.toString() ?? '',
      bedrooms: _parseInt(json['habitaciones']) ?? 0,
      bathrooms: _parseInt(json['banos']) ?? 0,
      floor: _parseInt(json['piso']) ?? 1,
      images: _parseImages(json['imagenes']),
      user: User.fromJson(json['usuario'] ?? {}),
      city: City.fromJson(json['ciudad'] ?? {}),
      company: Company.fromJson(json['empresa'] ?? {}),
      
    );
  }

  // Métodos auxiliares para parseo seguro (igual que en los otros modelos)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static List<String> _parseImages(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}
