class House {
  final int id;
  final String title;
  final String description;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final int garage;
  final int floors;
  final DateTime publishedAt;
  final List<String> images;

  House({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.garage,
    required this.floors,
    required this.publishedAt,
    required this.images,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    // Extraemos las imágenes y les agregamos la url base si es necesario
    List<String> imgs = [];
    if (json['imagenes'] != null) {
      imgs = List<String>.from(json['imagenes'].map((img) => 'http://localhost:3000$img'));
    }

    return House(
      id: json['id'] ?? 0,
      title: json['titulo'] ?? 'Sin título',
      description: json['descripcion'] ?? '',
      price: (json['precio'] != null) ? double.tryParse(json['precio'].toString()) ?? 0 : 0,
      bedrooms: json['habitaciones'] ?? 0,
      bathrooms: json['banos'] ?? 0,
      garage: json['garage'] ?? 0,
      floors: json['pisos'] ?? 0,
      publishedAt: DateTime.tryParse(json['fecha_publicacion'] ?? '') ?? DateTime.now(),
      images: imgs,
    );
  }
}
