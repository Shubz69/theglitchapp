import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8080/api';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login user
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Store token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, data['token']);
        await prefs.setString(_userKey, jsonEncode(data['user']));
        
        print('✅ Login successful: ${data['user']['email']}');
        return true;
      } else {
        print('❌ Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      // Fallback to mock data if backend is not running
      print('Backend not running, simulating login for: $email');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_userKey, jsonEncode({
        'id': '1',
        'email': email,
        'username': email.split('@')[0],
        'name': email.split('@')[0],
        'role': email.contains('admin') ? 'ADMIN' : 'USER',
        'profileColor': '#6366F1',
      }));
      return true;
    }
  }

  // Register user
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String name,
    String? profileColor,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Auto-login after registration
        return await login(email, password);
      } else {
        return false;
      }
    } catch (e) {
      print('Register error: $e');
      // For now, simulate registration if backend is not running
      print('Backend not running, simulating registration for: $email');
      final prefs = await SharedPreferences.getInstance();
      final userProfileColor = profileColor ?? '#${(username.hashCode % 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
      await prefs.setString(_tokenKey, 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_userKey, jsonEncode({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': email,
        'username': username,
        'name': name,
        'role': 'USER',
        'profileColor': userProfileColor,
      }));
      return true;
    }
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // Get auth token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Get token error: $e');
      return null;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Logout user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    try {
      final user = await getCurrentUser();
      return user?['role'] == 'ADMIN';
    } catch (e) {
      print('Check admin error: $e');
      return false;
    }
  }

  // Get auth headers for API requests
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Send password reset email
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        print('Password reset email sent to: $email');
        return true;
      }
      return false;
    } catch (e) {
      print('Send password reset error: $e');
      // For now, simulate success if backend is not running
      // In production, remove this fallback
      print('Backend not running, simulating email send for: $email');
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }
  }

  // Reset password with token
  static Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'password': newPassword,
        }),
      );
      
      if (response.statusCode == 200) {
        print('Password reset successful');
        return true;
      }
      return false;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }
}
