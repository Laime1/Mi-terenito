class Location{
  final int id;
  final String detailLocation;
  final String province;

  Location({
    required this.id,
    required this.detailLocation,
    required this.province,
  });

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
        id: json['id_ubicacion'] ?? 0,
        detailLocation: json['direccion_detallada'] ?? '',
        province: json['provincia'] ?? '',
    );
  }
}