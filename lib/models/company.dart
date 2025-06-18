class Company {
  final int id;
  final String name;
  final String description;
  final String phone;
    final String email;


  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.email,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id_empresa'] ?? 0,
      name: json['nombre_empresa']?.toString() ?? '',
      description: json['descripcion']?.toString()  ?? '',
      phone: json['telefono']?.toString() ?? '',
      email: json['correo']?.toString() ?? '',
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