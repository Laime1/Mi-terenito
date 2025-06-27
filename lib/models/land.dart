import 'package:mi_terrenito/models/user.dart';
import 'package:mi_terrenito/models/city.dart';
import 'package:mi_terrenito/models/company.dart';

class Land {
  final int id;
  final String title;
  final String description;
  final double price;
  final DateTime? createdAt;
  final int status;
  final DateTime publishedAt;
  final String mapLocation;
  final double size;
  final String basicServices;
  final List<String> images;
  final User? user;
  final City? city;
  final Company? company;

  Land({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.createdAt,
    required this.status,
    required this.publishedAt,
    required this.mapLocation,
    required this.size,
    required this.basicServices,
    required this.images,
    required this.user,
    required this.city,
    required this.company,
  });

  factory Land.fromJson(Map<String, dynamic> json) { 
    return Land(
      id: _parseInt(json['id_terreno']),
      title: json['titulo']?.toString() ?? '',
      description: json['descripcion']?.toString() ?? '',
      price: _parseDouble(json['precio']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      status: _parseInt(json['estado']),
      publishedAt: _parseDateTime(json['fecha_publicacion']),
      mapLocation: json['enlace_ubicacion']?.toString() ?? '',
      size: _parseDouble(json['tamano']),
      basicServices: json['servicios_basicos']?.toString() ?? '',
      images: _parseImages(json['imagenes']),
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
      return value.map((e) {
        if (e is String) return e;
        if (e is Map<String, dynamic>) return e['url_imagen']?.toString() ?? '';
        return '';
      }).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}
