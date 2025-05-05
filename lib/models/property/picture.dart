class Picture{
  final int id;
  final String urlNew;
  final int idProperty;
  final DateTime createdAt;
  final DateTime updatedUp;
  final String url;

  Picture({
    required this.id,
    required this.url,
    required this.idProperty,
    required this.createdAt,
    required this.updatedUp,
    required this.urlNew,
  });

  factory Picture.fromJson(Map<String, dynamic> json){

    return Picture(
        id: json['id_imagen'] ?? 0,
        url: json['url'] ?? '',
        urlNew: json['ruta_imagen'] ?? '',
        idProperty: json['id_propiedad'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedUp: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}