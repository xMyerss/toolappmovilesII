import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/GeolocationPage.dart';
import 'Pages/QRScanPage.dart';
import 'Pages/SensorsPage.dart';
import 'Pages/SpeechToTextPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal, // Cambié el color primario a teal
        scaffoldBackgroundColor: Colors.grey[100], // Fondo gris claro
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent, // Botones verde claro
            foregroundColor: Colors.black, // Texto negro
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/geolocation': (context) => const GeolocationPage(),
        '/qrscan': (context) => const QRScanPage(),
        '/sensors': (context) => const SensorsPage(),
        '/speech_text': (context) => SpeechTextPage(),
      },
    );
  }
}
