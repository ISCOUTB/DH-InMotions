import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      'http://10.0.2.2:5000/api'; // Cambia esto si usas iOS o un dispositivo físico

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> getEmotions(DateTime date) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(
          '$baseUrl/emotions?date=${date.toIso8601String().split('T')[0]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get emotions');
    }
  }

  Future<void> saveEmotion(DateTime date, String emotion) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/emotions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': date.toIso8601String().split('T')[0],
        'emotion': emotion,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save emotion');
    }
  }
}
