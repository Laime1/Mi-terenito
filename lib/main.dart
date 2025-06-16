import 'package:flutter/material.dart';
import 'package:mi_terrenito/screens/home_screen.dart';
import 'package:mi_terrenito/screens/houses1_scren.dart';
import 'package:mi_terrenito/screens/rentals_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Terrenito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     
      home:  HomeScreen(),


    );
  }
}