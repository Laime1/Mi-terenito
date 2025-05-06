import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Función para obtener los datos del usuario desde la API
  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/usuarios/11'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Establecer los datos recuperados en los controladores de texto
        setState(() {
          _nameController.text = data['nombre_usuario'] ?? '';
          _phoneController.text = data['contacto'] ?? '';
          _emailController.text = data['correo'] ?? '';
        });
      } else {
        // Si la respuesta no es exitosa, mostrar un error
        _showErrorDialog('Error al cargar los datos del usuario');
      }
    } catch (e) {
      // Manejar errores de la petición HTTP
      _showErrorDialog('Error de conexión');
    }
  }

  // Mostrar un diálogo de error
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
          crossAxisAlignment: CrossAxisAlignment.center,  // Centrar los elementos
          children: [
            // Foto de perfil centrada
            const SizedBox(height: 24),
            Center(  // Usamos Center para asegurar que la imagen esté centrada
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            // Titulo centrado
            const Text(
              'Perfil de Usuario',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'InknutAntiqua',  // Fuente aplicada
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
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        backgroundColor: const Color.fromARGB(255, 107, 131, 150),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget para mostrar solo los datos sin opción de editar
  Widget _buildDisplayField({
    required String label,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),  // Añadir espaciado vertical entre cada campo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // Alineación a la izquierda
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'InknutAntiqua', // Fuente aplicada
              fontWeight: FontWeight.w600, // Negrita para las etiquetas
            ),
          ),
          const SizedBox(height: 4),
          // Aseguramos que el texto esté alineado correctamente con un contenedor
          Container(
            width: double.infinity,  // Asegura que ocupe todo el ancho disponible
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),  // Agregar borde para dar el estilo de campo
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'InknutAntiqua', // Fuente aplicada
                fontWeight: FontWeight.w400, // Peso regular para el texto
              ),
            ),
          ),
        ],
      ),
    );
  }
}
