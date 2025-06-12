import 'package:mi_terrenito/models/user.dart';

class House {
  final int id;
  final String title;
  final String description;
  final double price;
  final int status;
  final DateTime publishedAt;
  final String mapLocation;
  final int bedrooms;
  final int bathrooms;
  final String garage;
  final int floors;
  final List<String> images;
  final int idCiudad;

  House({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.publishedAt,
    required this.mapLocation,
    required this.bedrooms,
    required this.bathrooms,
    required this.garage,
    required this.floors,
    required this.images,
    required this.idCiudad,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: _parseInt(json['id_casa']),
      title: json['titulo']?.toString() ?? '',
      description: json['descripcion']?.toString() ?? '',
      price: _parseDouble(json['precio']),
      status: _parseInt(json['estado']),
      publishedAt: _parseDateTime(json['fecha_publicacion']),
      mapLocation: json['enlace_ubicacion']?.toString() ?? '',
      bedrooms: _parseInt(json['habitaciones']),
      bathrooms: _parseInt(json['banos']),
      garage: json['cochera']?.toString() ?? 'No',
      floors: _parseInt(json['pisos']),
      images: _parseImages(json['imagenes']),
      idCiudad: _parseInt(json['id_ciudad']),
    );
  }

  // Métodos auxiliares para parseo seguro
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
        if (e is Map) return e['url_imagen']?.toString() ?? '';
        return '';
      }).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}