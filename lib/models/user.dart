class User{
  final int id;
  final String name;
  final String email;
  final String numberPhone;
  final int role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.numberPhone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
    id: json['id_usuario'] ?? 0,
    name: json['nombre_usuario'] ?? '',
    email: json['correo'] ?? '',
    numberPhone: json['contacto'] ?? '',
    role: json['id_rol'] ?? 0,
  );
  
  }
  

}