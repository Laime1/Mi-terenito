class Department{
  final int id;
  final String title;
  final String description;
  final double? price;
  final String status;
  final DateTime? publishDate;
  final String locationLink;
  final int? bedrooms;
  final int bathrooms;
  final int floor;
  final int userId;
  final int cityId;

  Department({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.publishDate,
    required this.locationLink,
    required this.bedrooms,
    required this.bathrooms,
    required this.floor,
    required this.userId,
    required this.cityId
 });


  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id_departamento'],
      title: json['titulo'],
      description: json['descripcion'],
      price: json['precio'] != null ? (json['precio'] as num).toDouble() : null,
      status: json['estado'],
      publishDate: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'])
          : null,
      locationLink: json['enlace_ubicacion'],
      bedrooms: json['habitaciones'],
      bathrooms: json['banos'],
      floor: json['piso'],
      userId: json['id_usuario'],
      cityId: json['id_ciudad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_departamento': id,
      'titulo': title,
      'descripcion': description,
      'precio': price,
      'estado': status,
      'fecha_publicacion': publishDate?.toIso8601String(),
      'enlace_ubicacion': locationLink,
      'habitaciones': bedrooms,
      'banos': bathrooms,
      'piso': floor,
      'id_usuario': userId,
      'id_ciudad': cityId,
    };
  }
}
