import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/app_theme.dart';
import 'package:mi_terrenito/screens/home2_screen.dart';
import 'package:mi_terrenito/screens/home_screen.dart';
import 'package:mi_terrenito/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final usuarioId = prefs.getInt('usuarioIdKey');
  final usuarioName = prefs.getString('usuarioNameKey');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(
        isLoggedIn: usuarioId != null,
        usuarioId: usuarioId,
        usuarioName: usuarioName,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final int? usuarioId;
  final String? usuarioName;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.usuarioId,
    this.usuarioName,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Mi Terrenito',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home:
          isLoggedIn
              ? Home2Screen(
                tipo: 'casas',
                empresaId: 1,
                cityId: 1,
                usuarioId: usuarioId!,
                usuarioName: usuarioName ?? 'Usuario',
                selectedCityName: '',
                selectedEmpresaName: '',
                hasCasas: true,
                hasTerrenos: true,
                hasDepartamentos: true,
                hasAlquileres: true,
                isLoggedIn: true,
              )
              : const HomeScreen(),
    );
  }
}
