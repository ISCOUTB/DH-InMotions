import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _checkLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString('users') ?? '';
      print('SharedPreferences contents: $users');
      List<String> userList = users.split('\n');
      for (var user in userList) {
        List<String> userData = user.split(':');
        if (userData.length >= 2 &&
            userData[0] == email &&
            userData[1] == password) {
          print('Login successful for $email');
          return true;
        }
      }
      print('User not found: $email');
      return false;
    } catch (e) {
      print('Error checking login: $e');
      return false;
    }
  }

  void _loginUser() async {
    bool loginSuccess =
        await _checkLogin(_emailController.text, _passwordController.text);
    if (loginSuccess) {
      Navigator.pushReplacementNamed(context, '/calendar');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Usuario o contraseña incorrectos'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
