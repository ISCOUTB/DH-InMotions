import 'package:flutter/material.dart';
import 'register_page.dart';
import 'emotion_list_page.dart';
import 'login_page.dart';
import 'emotion_calendar_page.dart';
import 'biblioteca_archivos.dart';
import 'RegisterMovil.dart';
import 'LoginMovil.dart';
import 'EmotionListMovil.dart';
import 'CalendarPageMovil.dart';
import 'BibliotecaMovil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienestar Mental - Móvil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/register': (context) => RegisterMovil(),
        '/login': (context) => LoginMovil(),
        '/emotion_list': (context) =>
            EmotionListMovil(userEmail: 'user@example.com'),
        '/calendar': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String?;
          return EmotionCalendarMovil(userEmail: email ?? 'user@example.com');
        },
        '/instructions': (context) => BibliotecaMovil(),
      },
    );
  }
}
