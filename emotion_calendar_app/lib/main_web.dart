import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'emotion_list_page.dart';
import 'login_page.dart';
import 'emotion_calendar_page.dart';
import 'biblioteca_archivos.dart'; // Importa la clase BibliotecaArchivos

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _createTestUser();
  runApp(MyApp());
}

Future<void> _createTestUser() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('users')) {
    await prefs.setString('users', 'testuser:testpassword' + ':Test User\n');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienestar Mental',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/emotion_list': (context) =>
            EmotionListPage(userEmail: 'user@example.com'),
        '/calendar': (context) =>
            EmotionCalendarPage(userEmail: 'testuser@example.com'),
        '/instructions': (context) =>
            BibliotecaArchivos(), // Cambia la ruta a BibliotecaArchivos
      },
    );
  }
}
