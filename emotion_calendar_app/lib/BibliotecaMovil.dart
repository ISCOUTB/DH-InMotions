import 'package:flutter/material.dart';

class BibliotecaMovil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca Movil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Instrucciones para el uso de la aplicación Bienestar Mental:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '1. Registro: Completa tus datos personales para comenzar a usar la app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Inicio de sesión: Ingresa con tu correo electrónico y contraseña.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Seguimiento de emociones: Registra tus emociones diarias y visualiza tu evolución.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Biblioteca: Accede a esta sección para ver más información de apoyo.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresar a la pantalla anterior
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
