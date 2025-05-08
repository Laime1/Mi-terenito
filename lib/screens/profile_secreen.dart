import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

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

  late int idUsuario;

  @override
  void initState() {
    super.initState();
    idUsuario = widget.idUsuario;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('https://api-terrenito-nodejs.onrender.com/api/usuarios/$idUsuario'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _nameController.text = data['nombre_usuario'] ?? '';
          _phoneController.text = data['contacto'] ?? '';
          _emailController.text = data['correo'] ?? '';
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Perfil de usuario',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: const Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Perfil de Usuario',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildDisplayField(
              label: 'Nombre de usuario: ',
              text: _nameController.text,
            ),
            const SizedBox(height: 16),
            _buildDisplayField(
              label: 'Telefono o celular: ',
              text: _phoneController.text,
            ),
            const SizedBox(height: 16),
            _buildDisplayField(
              label: 'Correo: ',
              text: _emailController.text,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(idUsuario: idUsuario)),
            (Route<dynamic> route) => false,
          );
        },
        backgroundColor: const Color.fromARGB(255, 107, 131, 150),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDisplayField({
    required String label,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'InknutAntiqua',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}