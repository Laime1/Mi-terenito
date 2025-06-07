class Rental {
  final int id;
  final String? title;
  final String? description;
  final int? monthlyPrice;
  final int? status;
  final DateTime? publishDate;
  final String? locationLink;
  final String? furnished;
  final int? minMonths;
  final String? includesServices;
  final int? userId;
  final int? cityId;

  Rental({
    required this.id,
    this.title,
    this.description,
    this.monthlyPrice,
    this.status,
    this.publishDate,
    this.locationLink,
    this.furnished,
    this.minMonths,
    this.includesServices,
    this.userId,
    this.cityId,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id_alquiler'],
      title: json['titulo'],
      description: json['descripcion'],
      monthlyPrice: json['precio_mensual'],
      status: json['estado'],
      publishDate: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'])
          : null,
      locationLink: json['enlace_ubicacion'],
      furnished: json['amoblado'],
      minMonths: json['tiempo_minimo_meses'],
      includesServices: json['incluye_servicios'],
      userId: json['id_usuario'],
      cityId: json['id_ciudad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alquiler': id,
      'titulo': title,
      'descripcion': description,
      'precio_mensual': monthlyPrice,
      'estado': status,
      'fecha_publicacion': publishDate?.toIso8601String(),
      'enlace_ubicacion': locationLink,
      'amoblado': furnished,
      'tiempo_minimo_meses': minMonths,
      'incluye_servicios': includesServices,
      'id_usuario': userId,
      'id_ciudad': cityId,
    };
  }
}
