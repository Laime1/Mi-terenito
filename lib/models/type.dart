
class Types{
  final int id;
  final String name;

  Types({
    required this.id,
    required this.name
  });

  factory Types.fromJson(Map<String, dynamic> json){
    return Types(
    id: json['id_tipo'] ?? 0,
    name: json['nombre'] ?? '',
  );
  }
}