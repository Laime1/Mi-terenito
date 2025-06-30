import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/app_theme.dart';
import 'package:mi_terrenito/screens/home_screen.dart';
import 'package:mi_terrenito/services/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Mi Terrenito',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      home: HomeScreen(),
    );
  }
}