import 'package:flutter/material.dart';
import 'CalendarPageMovil.dart';
import 'BibliotecaMovil.dart';
import 'EmotionListMovil.dart';
import 'LoginMovil.dart';
import 'RegisterMovil.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Página de inicio es el login
      routes: {
        '/login': (context) => LoginMovil(),
        '/register': (context) => RegisterMovil(),
        '/calendar': (context) => CalendarPageMovil(userEmail: ''), // Asegúrate de pasar el email del usuario
        '/biblioteca': (context) => BibliotecaMovil(), 
        '/emotionList': (context) => EmotionListMovil(userEmail: ''), 
      },
    );
  }
}
