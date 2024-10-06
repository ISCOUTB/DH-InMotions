import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserManager {
  static const String _usersKey = 'users';
  static const String _emotionsKey = 'emotions';

  // Register a new user
  static Future<bool> registerUser(
      String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString(_usersKey) ?? '';

      // Check if user already exists
      if (users.contains(email)) {
        return false; // User already exists
      }

      users += '$email:$password:$name\n';
      await prefs.setString(_usersKey, users);
      print('User registered: $email:$password:$name');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login user
  static Future<bool> loginUser(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString(_usersKey) ?? '';
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

  // Get user details
  static Future<Map<String, String>?> getUserDetails(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString(_usersKey) ?? '';
      List<String> userList = users.split('\n');
      for (var user in userList) {
        List<String> userData = user.split(':');
        if (userData.length >= 3 && userData[0] == email) {
          return {
            'email': userData[0],
            'name': userData[2],
          };
        }
      }
      return null;
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Update user details
  static Future<bool> updateUserDetails(
      String email, String newName, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString(_usersKey) ?? '';
      List<String> userList = users.split('\n');
      for (int i = 0; i < userList.length; i++) {
        List<String> userData = userList[i].split(':');
        if (userData.length >= 3 && userData[0] == email) {
          userList[i] = '$email:$newPassword:$newName';
          String updatedUsers = userList.join('\n');
          await prefs.setString(_usersKey, updatedUsers);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating user details: $e');
      return false;
    }
  }

  // Delete user
  static Future<bool> deleteUser(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String users = prefs.getString(_usersKey) ?? '';
      List<String> userList = users.split('\n');
      userList.removeWhere((user) => user.split(':')[0] == email);
      String updatedUsers = userList.join('\n');
      await prefs.setString(_usersKey, updatedUsers);
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Save emotion (now only for the specific user)
  static Future<void> saveEmotion(
      String email, String emotion, String note) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userEmotions = prefs.getString(email) ?? '[]'; // Use email as key
      List<Map<String, dynamic>> emotionList =
          List<Map<String, dynamic>>.from(json.decode(userEmotions));

      emotionList.add({
        'emotion': emotion,
        'note': note,
        'date': DateTime.now().toIso8601String(),
      });

      await prefs.setString(
          email, json.encode(emotionList)); // Save only for the specific user
    } catch (e) {
      print('Error saving emotion: $e');
    }
  }

  // Get emotions (now only for the specific user)
  static Future<List<Map<String, dynamic>>> getEmotions(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userEmotions = prefs.getString(email) ?? '[]'; // Use email as key
      List<Map<String, dynamic>> emotionList =
          List<Map<String, dynamic>>.from(json.decode(userEmotions));

      return emotionList;
    } catch (e) {
      print('Error getting emotions: $e');
      return [];
    }
  }
}
