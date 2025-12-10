import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://10.109.162.110:8000/api';

  // Secure Storage
  static const _tokenKey = 'access_token';
  static const _onboardingKey = 'onboarding_complete';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ============================================================
  // REGISTER
  // ============================================================
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['access_token'] != null) {
        await storage.write(key: _tokenKey, value: body['access_token']);
      }

      return body;
    } catch (e) {
      return {'error': true, 'message': 'Erreur réseau : $e'};
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['access_token'] != null) {
        await storage.write(key: _tokenKey, value: body['access_token']);
      }

      return body;
    } catch (e) {
      return {'error': true, 'message': 'Erreur réseau : $e'};
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    try {
      final token = await storage.read(key: _tokenKey);

      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      }

      await storage.delete(key: _tokenKey);
    } catch (_) {
      await storage.delete(key: _tokenKey);
    }
  }

  // ============================================================
  // CHECK IF LOGGED
  // ============================================================
  Future<bool> isUserLoggedIn() async {
    final token = await storage.read(key: _tokenKey);
    return token != null;
  }

  // ============================================================
  // GET USER PROFILE
  // ============================================================
  Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await storage.read(key: _tokenKey);

      final res = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {'error': true, 'message': 'Erreur réseau : $e'};
    }
  }

  // ============================================================
  // UPDATE USER PROFILE
  // ============================================================
 Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
  try {
    final token = await storage.read(key: _tokenKey);

    if (token == null) {
      return {'error': true, 'message': 'Non autenticato'};
    }

    final res = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 401) {
      return {'error': true, 'message': 'Token non valido o scaduto'};
    }

    final body = jsonDecode(res.body);
    return body;
  } catch (e) {
    return {'error': true, 'message': 'Errore rete: $e'};
  }
}


  // ============================================================
  // ONBOARDING
  // ============================================================
  Future<void> setOnboardingComplete() async {
    await storage.write(key: _onboardingKey, value: 'true');
  }

  Future<bool> isOnboardingComplete() async {
    return await storage.read(key: _onboardingKey) == 'true';
  }
}
