import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Initialisation de FlutterSecureStorage (sécurisé pour les jetons)
final storage = FlutterSecureStorage();
final baseUrl = 'http://10.109.162.110:8000/api';

class AuthService {
  // Clés de stockage
  static const String _tokenKey = 'token';
  static const String _onboardingKey = 'onboarding_complete';
  
  // -----------------------------------------------------------------
  // Méthodes d'authentification
  // -----------------------------------------------------------------

  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    final responseData = jsonDecode(res.body);
    
    // Sauvegarde le jeton si l'enregistrement est réussi
    if (responseData['access_token'] != null) {
      await storage.write(key: _tokenKey, value: responseData['access_token']);
    }
    return responseData;
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    
    // Sauvegarde le jeton si la connexion est réussie
    if (data['access_token'] != null) {
      await storage.write(key: _tokenKey, value: data['access_token']);
    }
    return data;
  }
  
  // -----------------------------------------------------------------
  // Méthodes de gestion de l'état de l'utilisateur
  // -----------------------------------------------------------------

  // Vérifie si un jeton existe (pour la connexion automatique)
  Future<bool> isUserLoggedIn() async {
    final token = await storage.read(key: _tokenKey);
    return token != null;
  }
  
  // Logout (Déconnexion)
  Future<void> logout() async {
    final token = await storage.read(key: _tokenKey);
    if (token != null) {
      // Tente d'appeler l'API pour invalider le jeton (bonne pratique)
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    }
    // Supprime le jeton localement
    await storage.delete(key: _tokenKey);
  }

  // Get user info (Utilise la clé de stockage définie)
  Future<Map<String, dynamic>> getUser() async {
    final token = await storage.read(key: _tokenKey);
    final res = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return jsonDecode(res.body);
  }

  // Update profile (Utilise la clé de stockage définie)
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final token = await storage.read(key: _tokenKey);
    final res = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // -----------------------------------------------------------------
  // Méthodes de gestion de l'Onboarding
  // -----------------------------------------------------------------
  
  // Marque l'onboarding comme terminé
  Future<void> setOnboardingComplete() async {
    await storage.write(key: _onboardingKey, value: 'true');
  }

  // Vérifie si l'onboarding a été vu
  Future<bool> isOnboardingComplete() async {
    return (await storage.read(key: _onboardingKey)) == 'true';
  }
}