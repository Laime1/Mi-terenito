import 'package:mi_terrenito/models/property/location.dart';
import 'package:mi_terrenito/models/property/picture.dart';
import 'package:mi_terrenito/models/property/type.dart';
import 'package:mi_terrenito/models/user.dart';

class Property{
  final int id;
  final String name;
  final double size;
  final List<Picture> images;
  final String description;
  final double minPrice;
  final double maxPrice;
  final String zone;
  final String mapLocation;
  final int status;
  final DateTime createdAt;
  final DateTime updatedUp;
  final User user;
  final Location location;
  final Types type;
  final int idTipe;

  

  Property({
    required this.id,
    required this.name,
    required this.size,
    required this.images,
    required this.description,
    required this.minPrice,
    required this.maxPrice,
    required this.zone,
    required this.mapLocation,
    required this.status,
    required this.createdAt,
    required this.updatedUp,
    required this.user,
    required this.type,
    required this.location,
    required this.idTipe,

  });

 factory Property.fromJson(Map<String, dynamic> json){
   return Property(
       name: json['titulo'] ?? 'Sin titulo',
       size: double.tryParse(json['tamano'].toString()) ?? 0.0,
       images: (json['imagenes'] as List<dynamic>?)
         ?.map((img) => Picture.fromJson(img))
         .toList() ?? [],
       description: json['descripcion'] ?? '',
       minPrice: double.tryParse(json['precio_min']?.toString() ?? '0') ?? 0.0,
       maxPrice: double.tryParse(json['precio_max']?.toString() ?? '0') ?? 0.0,
       zone: json['zona'] ?? '',
       //location: json['location'] ?? '',
       mapLocation: json['Enlace_ubicacion'] ?? '',
       id: json['id_propiedad'] ?? 0,
       status: json['estado'] ?? 1,
       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
       updatedUp: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
       user: User.fromJson(json['usuario'] ?? {}),
       location: Location.fromJson(json['ubicacion'] ?? {}),
       type: Types.fromJson(json['tipo'] ?? {}),
       idTipe: json['id_tipo'] ?? 1,
   );
 }

  bool isLand() => type.name.toLowerCase().contains('terreno');
  bool isRental() => type.name.toLowerCase().contains('alquiler');
  bool isHouse() => type.name.toLowerCase().contains('casa');

}