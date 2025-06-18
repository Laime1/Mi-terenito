class City {
  final int id;
  final String name;

  City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id_ciudad'],
      name: json['nombre_ciudad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ciudad': id,
      'nombre_ciudad': name,
    };
  }
}