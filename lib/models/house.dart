import 'package:mi_terrenito/models/city.dart';
import 'package:mi_terrenito/models/company.dart';
import 'package:mi_terrenito/models/user.dart';

class House {
  final int id;
  final String title;
  final String description;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final bool garage;
  final int floors;
  final int status;
  final DateTime publishedAt;
  final List<String> images;
  final String mapLocation;
  final User? user;
  final City? city;
  final Company? company;

  House({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.garage,
    required this.floors,
    required this.status,
    required this.publishedAt,
    required this.images,
    required this.mapLocation,
    required this.user,
    required this.city,
    required this.company,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: _parseInt(json['id_casa']),
      title: json['titulo']?.toString() ?? '',
      description: json['descripcion']?.toString() ?? '',
      price: _parseDouble(json['precio']),
      bedrooms: _parseInt(json['habitaciones']),
      bathrooms: _parseInt(json['banos']),
      garage: (json['cochera']?.toString().toLowerCase() == 'true'),
      floors: _parseInt(json['pisos']),
      status: _parseInt(json['estado']),
      publishedAt: _parseDateTime(json['fecha_publicacion']),
      images: _parseImages(json['imagenes']),
      mapLocation: json['enlace_ubicacion']?.toString() ?? '',
      user: User.fromJson(json['usuario'] ?? {}),
      city: City.fromJson(json['ciudad'] ?? {}),
      company: Company.fromJson(json['empresa'] ?? {}),
    );
  }

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
