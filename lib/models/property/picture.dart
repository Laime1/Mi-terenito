class Picture{
   final int id;
  // final String urlNew;
   final int idProperty;
   final DateTime createdAt;
   final DateTime updatedUp;
  final String url;

  Picture({
    required this.url,
     required this.id,
     required this.idProperty,
     required this.createdAt,
     required this.updatedUp,
    // required this.urlNew,
  });

  factory Picture.fromJson(Map<String, dynamic> json){

    return Picture(
      url: json['ruta_imagen'] ?? '',
        id: json['id_imagen'] ?? 0,
      //  urlNew: json['ruta_imagen'] ?? '',
         idProperty: json['id_propiedad'] ?? 0,
       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
       updatedUp: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}