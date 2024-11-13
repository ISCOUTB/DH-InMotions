import 'package:flutter/material.dart';
import 'UserManagerMovil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMovil extends StatefulWidget {
  @override
  _LoginMovilState createState() => _LoginMovilState();
}

class _LoginMovilState extends State<LoginMovil> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa un correo y una contraseña.';
      });
      return;
    }

    final users = await UserManagerMovil.getUsers();
    final user = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {});

    if (user.isEmpty) {
      setState(() {
        _errorMessage = 'Credenciales incorrectas';
      });
    } else {
      // Guardamos el correo para futuras sesiones
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);

      // Redirigir a la pantalla de emociones
      Navigator.pushReplacementNamed(context, '/calendar', arguments: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar sesión'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
