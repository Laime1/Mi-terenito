import 'package:mi_terrenito/models/user.dart';
import 'package:mi_terrenito/models/property/location.dart';
import 'package:mi_terrenito/models/property/picture.dart';

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
  final List<Picture> images;
  final User user;
  final Location location;
  final int idUsuario;
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
    required this.user,
    required this.location,
    required this.idUsuario,
    required this.idCiudad,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id_casa'] ?? 0,
      title: json['titulo'] ?? '',
      description: json['descripcion'] ?? '',
      price: double.tryParse(json['precio'].toString()) ?? 0.0,
      status: json['estado'] ?? 1,
      publishedAt: DateTime.tryParse(json['fecha_publicacion'] ?? '') ?? DateTime.now(),
      mapLocation: json['enlace_ubicacion'] ?? '',
      bedrooms: json['habitaciones'] ?? 0,
      bathrooms: json['banos'] ?? 0,
      garage: json['cochera'] ?? '',
      floors: json['pisos'] ?? 1,
      images: (json['imagenes'] as List<dynamic>?)
              ?.map((img) => Picture.fromJson(img))
              .toList() ?? [],
      user: User.fromJson(json['usuario'] ?? {}),
      location: Location.fromJson(json['ubicacion'] ?? {}),
      idUsuario: json['id_usuario'] ?? 0,
      idCiudad: json['id_ciudad'] ?? 0,
    );
  }
}
