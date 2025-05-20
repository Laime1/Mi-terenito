import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_terrenito/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final int idUsuario;
  const ProfileScreen({super.key, required this.idUsuario});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String rolNombre = '';

  final Map<int, String> rolesMap = {
    1: 'Administrador',
    2: 'Usuario',
    3: 'Invitado',
  };

  late int idUsuario;

  @override
  void initState() {
    super.initState();
    idUsuario = widget.idUsuario;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/usuarios/$idUsuario'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _nameController.text = data['nombre_usuario'] ?? '';
          _phoneController.text = data['contacto'] ?? '';
          _emailController.text = data['correo'] ?? '';
          int idRol = data['id_rol'] ?? 0;
          rolNombre = rolesMap[idRol] ?? 'Rol no definido';
        });
      } else {
        _showErrorDialog('Error al cargar los datos del usuario');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const gradientColors = [
      Color(0xFFEAF2F8),
      Color(0xFFCAD6E2),
      Color(0xFF9BA7B4),
      Color(0xFF7C8694),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Perfil de usuario',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                rolNombre.isNotEmpty ? rolNombre : 'Perfil de Usuario',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 36),
              _buildProfileItem(
                icon: Icons.person,
                title: 'Nombre',
                subtitle: _nameController.text,
              ),
              const SizedBox(height: 24),
              _buildProfileItem(
                icon: Icons.phone,
                title: 'Teléfono',
                subtitle: _phoneController.text,
              ),
              const SizedBox(height: 24),
              _buildProfileItem(
                icon: Icons.email,
                title: 'Correo',
                subtitle: _emailController.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[800], size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle.isNotEmpty ? subtitle : 'No disponible',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}