import 'package:mi_terrenito/models/user.dart';

class Land {
  final int id;
  final String title;
  final String description;
  final double price;
  final int status;
  final DateTime publishedAt;
  final String mapLocation;
  final double size;
  final String basicServices;
  final List<String> images; // solo URLs
  final User user;
  final int idUsuario;
  final int idCiudad;

  Land({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.publishedAt,
    required this.mapLocation,
    required this.size,
    required this.basicServices,
    required this.images,
    required this.user,
    required this.idUsuario,
    required this.idCiudad,
  });

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      id: json['id_terreno'] ?? 0,
      title: json['titulo'] ?? '',
      description: json['descripcion'] ?? '',
      price: double.tryParse(json['precio'].toString()) ?? 0.0,
      status: json['estado'] ?? 1,
      publishedAt: DateTime.tryParse(json['fecha_publicacion'] ?? '') ?? DateTime.now(),
      mapLocation: json['enlace_ubicacion'] ?? '',
      size: double.tryParse(json['tamano'].toString()) ?? 0.0,
      basicServices: json['servicios_basicos'] ?? 'No',
      images: (json['imagenes'] as List<dynamic>? ?? []).map((img) {
        if (img is String) {
          return img;
        } else if (img is Map<String, dynamic>) {
          return img['url_imagen'].toString();
        } else {
          return '';
        }
      }).where((url) => url.isNotEmpty).toList(),
      user: User.fromJson(json['usuario'] ?? {}),
      idUsuario: json['id_usuario'] ?? 0,
      idCiudad: json['id_ciudad'] ?? 0,
    );
  }
}
