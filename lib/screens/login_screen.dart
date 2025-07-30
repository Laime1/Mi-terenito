import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_terrenito/services/api_service.dart';
import 'home2_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController correoController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();
    final ValueNotifier<bool> obscurePassword = ValueNotifier(true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children:[
          Positioned.fill(
            child: Image(
              image: AssetImage('assets/background/fondo_1.jpg'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
                   ),
          ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/icono_terreno.png',
                  height: 400,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 350,
                  height: 45,
                  child: TextField(
                    controller: correoController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      hintText: 'ingresar correo',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF006666),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 350,
                  height: 45,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
                    builder: (context, value, child) {
                      return TextField(
                        controller: contrasenaController,
                        obscureText: value,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: 'ingresar contraseña',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Color(0xFF006666),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              value ? Icons.visibility_off : Icons.visibility,
                              color: Theme.of(context).iconTheme.color,
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
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
        ]
      ),
    );
  }

  Future<void> login(BuildContext context, String correo, String contrasena) async {
    final url = Uri.parse('${ApiService.baseUrl}/usuarios/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'correo': correo, 'contraseña': contrasena}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final usuario = data['usuario'];

      if (usuario != null) {
        int empresaId = usuario['id_empresa'];
        int ciudadId = 1;
        int usuarioId = usuario['id_usuario'];
        String nombreUsuario = usuario['nombre_usuario'] ?? 'Usuario';


        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioNameKey', nombreUsuario);
        await prefs.setInt('usuarioIdKey', usuarioId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home2Screen(
              tipo: 'casas',
              empresaId: empresaId,
              cityId: ciudadId,
              usuarioId: usuarioId,
              usuarioName: nombreUsuario,
              selectedCityName: '',
              selectedEmpresaName: '',
              hasCasas: true,
              hasTerrenos: true,
              hasDepartamentos: true,
              hasAlquileres: true,
              isLoggedIn: true,
            ),
          ),
          (route) => false,
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