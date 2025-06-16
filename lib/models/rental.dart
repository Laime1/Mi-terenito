class Rental {
  final int id;
  final String title;
  final String description;
  final double monthlyPrice;
  final int status;
  final DateTime publishedAt;
  final String mapLocation;
  final String furnished;
  final int minimumMonths;
  final String includedServices;
  final List<String> images;
  final int cityId;

  Rental({
    required this.id,
    required this.title,
    required this.description,
    required this.monthlyPrice,
    required this.status,
    required this.publishedAt,
    required this.mapLocation,
    required this.furnished,
    required this.minimumMonths,
    required this.includedServices,
    required this.images,
    required this.cityId,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: _parseInt(json['id_alquiler']),
      title: json['titulo']?.toString() ?? '',
      description: json['descripcion']?.toString() ?? '',
      monthlyPrice: _parseDouble(json['precio_mensual']),
      status: _parseInt(json['estado']),
      publishedAt: _parseDateTime(json['fecha_publicacion']),
      mapLocation: json['enlace_ubicacion']?.toString() ?? '',
      furnished: json['amoblado']?.toString() ?? 'No',
      minimumMonths: _parseInt(json['tiempo_minimo_meses']),
      includedServices: json['incluye_servicios']?.toString() ?? '',
      images: _parseImages(json['imagenes']),
      cityId: _parseInt(json['ciudad']?['id_ciudad']),
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
        if (e is Map) return e['url_imagen']?.toString() ?? '';
        return '';
      }).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}