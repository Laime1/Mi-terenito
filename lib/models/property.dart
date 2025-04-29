import 'package:mi_terrenito/models/location.dart';
import 'package:mi_terrenito/models/picture.dart';
import 'package:mi_terrenito/models/type.dart';
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

  

  Property({
    required this.id,
    required this.name,
    required this.size,
    required this.images,
    required this.description,
    required this.minPrice,
    required this.maxPrice,
    required this.zone,
    //required this.location,
    required this.mapLocation,
    required this.status,
    required this.createdAt,
    required this.updatedUp,
    required this.user,
    required this.type,
    required this.location,
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
   );
 }
}