import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class UserManagerMovil {
  static const String _usersKey = 'usersData';

  /// Inicializa el JSON desde assets a SharedPreferences si aún no existe
  static Future<void> initializeUsers() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_usersKey)) {
      // Carga el JSON desde assets solo si aún no está en SharedPreferences
      final jsonString = await rootBundle.loadString('assets/users.json');
      await prefs.setString(_usersKey, jsonString);
    }
  }

  /// Obtiene la lista de usuarios desde SharedPreferences
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);

    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((user) => user as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  /// Añade un usuario y guarda la lista actualizada en SharedPreferences
  static Future<void> addUser(String email, String password) async {
    final users = await getUsers();
    users.add({
      'email': email,
      'password': password,
    });
    await _saveUsers(users);
  }

  /// Añade una emoción a un usuario específico y guarda los datos actualizados
  static Future<void> addEmotion(
      String email, DateTime date, String emotion, String note) async {
    final prefs = await SharedPreferences.getInstance();

    // Primero obtén la lista de emociones guardadas para este usuario.
    List<Map<String, dynamic>> emotions = await getEmotions(email);

    // Añadir la nueva emoción a la lista
    emotions.add({
      'date': date.toIso8601String(),
      'emotion': emotion,
      'note': note,
    });

    // Guardar la lista de emociones actualizada con una clave única por usuario
    await prefs.setString(email, json.encode(emotions));
  }

  /// Obtiene la lista de emociones de un usuario específico
  static Future<List<Map<String, dynamic>>> getEmotions(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(email);

    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData
          .map((emotion) => emotion as Map<String, dynamic>)
          .toList();
    } else {
      return []; // Si no hay emociones, retornar una lista vacía
    }
  }

  /// Guarda la lista de usuarios en SharedPreferences
  static Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(users);
    await prefs.setString(_usersKey, jsonString);
  }
}
