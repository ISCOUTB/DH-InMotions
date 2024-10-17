import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'emotion_list_page.dart';
import 'login_page.dart';
import 'emotion_calendar_page.dart';
import 'biblioteca_archivos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
        '/calendar': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String?;
          return EmotionCalendarPage(userEmail: email ?? 'user@example.com');
        },
        '/instructions': (context) => BibliotecaArchivos(),
      },
    );
  }
}
