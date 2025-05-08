import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_terrenito/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController correoController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();
    final ValueNotifier<bool> obscurePassword = ValueNotifier(true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Mi TERRENITO",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'InknutAntiqua',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/icono_terreno.png',
                height: 200,
              ),
              const SizedBox(height: 30),
              Container(
                width: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: correoController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        hintText: 'ingresar correo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (context, value, child) {
                        return TextField(
                          controller: contrasenaController,
                          obscureText: value,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'ingresar contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(
                                value ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                obscurePassword.value = !value;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          login(context, correoController.text, contrasenaController.text);
                        },
                        child: const Text("Iniciar sesión"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context, String correo, String contrasena) async {
    final url = Uri.parse('http://localhost:3000/api/usuarios/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'correo': correo, 'contraseña': contrasena}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('id_usuario')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(idUsuario: data['id_usuario'])),
        );
      } else {
        _showErrorDialog(context, 'Credenciales incorrectas');
      }
    } else {
      _showErrorDialog(context, 'Error al iniciar sesión');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}