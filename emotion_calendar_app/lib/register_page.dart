import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString('users') ?? '';
      users += '$email:$password:$name\n';
      await prefs.setString('users', users);
      print('User registered: $email:$password:$name');

      // Verify the contents after writing
      String contents = prefs.getString('users') ?? '';
      print('SharedPreferences contents after registration: $contents');
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                await _registerUser(_nameController.text, _emailController.text,
                    _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuario registrado')),
                );
                Navigator.pop(context);
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
