import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_terrenito/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController correoController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();
    final ValueNotifier<bool> obscurePassword = ValueNotifier(true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent, 
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFEAF2F8),
                Color(0xFFCAD6E2), 
                Color(0xFF9BA7B4), 
                Color(0xFF7C8694), 
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAF2F8), 
              Color(0xFFCAD6E2), 
              Color(0xFF9BA7B4), 
              Color(0xFF7C8694), 
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "CLICK HOUSE",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'InknutAntiqua',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/icono_terreno.png',
                  height: 300,
                ),
                const SizedBox(height: 30),

                // Campo correo reducido
                SizedBox(
                  width: 350,
                  height: 45,
                  child: TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      hintText: 'ingresar correo',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.0),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Campo contraseña reducido
                SizedBox(
                  width: 350,
                  height: 45,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
                    builder: (context, value, child) {
                      return TextField(
                        controller: contrasenaController,
                        obscureText: value,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: 'ingresar contraseña',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                ),
                const SizedBox(height: 20),

                // Botón de login
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
        ),
      ),
    );
  }

  Future<void> login(BuildContext context, String correo, String contrasena) async {
    final url = Uri.parse('${ApiService.baseUrl}/usuarios/login/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'correo': correo, 'contraseña': contrasena}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('id_usuario')) {
        Navigator.pop(context, data['id_usuario']);
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
