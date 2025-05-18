class Location{
   int _id;
  final String detailLocation;
  final String province;

  Location({
    required int id,
    required this.detailLocation,
    required this.province,
  }): _id = id;

   // Getter para id
   int get id => _id;

   // Setter para id
   set id(int value) {
     _id = value;
   }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
        id: json['id_ubicacion'] ?? 0,
        detailLocation: json['direccion_detallada'] ?? '',
        province: json['provincia'] ?? '',
    );
  }

   @override
   bool operator ==(Object other) =>
       identical(this, other) ||
           other is Location && runtimeType == other.runtimeType && id == other.id;

   @override
   int get hashCode => id.hashCode;
}