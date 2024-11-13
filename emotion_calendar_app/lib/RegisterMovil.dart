import 'package:flutter/material.dart';
import 'UserManagerMovil.dart';

class RegisterMovil extends StatefulWidget {
  @override
  _RegisterMovilState createState() => _RegisterMovilState();
}

class _RegisterMovilState extends State<RegisterMovil> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa un correo y una contraseña.';
      });
      return;
    }

    final users = await UserManagerMovil.getUsers();
    final userExists = users.any((user) => user['email'] == email);

    if (userExists) {
      setState(() {
        _errorMessage = 'El correo electrónico ya está registrado.';
      });
    } else {
      await UserManagerMovil.addUser(email, password);
      setState(() {
        _errorMessage = '';
      });

      // Redirigir al login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
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
              onPressed: _register,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
