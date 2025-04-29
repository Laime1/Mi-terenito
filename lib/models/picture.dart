class Picture{
  final int id;
  final String url;
  final int idProperty;
  final DateTime createdAt;
  final DateTime updatedUp;

  Picture({
    required this.id,
    required this.url,
    required this.idProperty,
    required this.createdAt,
    required this.updatedUp,
  });

  factory Picture.fromJson(Map<String, dynamic> json){

    return Picture(
        id: json['id_imagen'] ?? 0,
        url: json['ruta_imagen'] ?? '',
        idProperty: json['id_propiedad'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedUp: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}