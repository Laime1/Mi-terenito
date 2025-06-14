class Company {
  final int id;
  final String name;
  final String description;
  final String phone;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id_empresa'],
      name: json['nombre_empresa'],
      description: json['descripcion'],
      phone: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': id,
      'nombre_empresa': name,
      'descripcion': description,
      'telefono': phone,
    };
  }
}