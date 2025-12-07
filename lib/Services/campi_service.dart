import 'dart:convert';
import 'package:footbookcamp/Model/campi_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Récupération des variables globales de votre AuthService
final storage = FlutterSecureStorage();
// Assurez-vous que cette URL est correcte et accessible (attention à l'IP locale 10.65.206.110)
final baseUrl = 'http://10.109.162.110:8000/api'; 

class CampiService {
  
  // GET ALL Campi
  Future<List<Campo>> getAllCampi() async {
    final token = await storage.read(key: 'token');
    
    // Le chemin de votre route est /api/campi (si votre RouteServiceProvider utilise /api)
    final url = Uri.parse('$baseUrl/campi'); 
    
    try {
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Inclure l'Authorization si cette route est protégée par Sanctum/Bearer Token
          'Authorization': 'Bearer $token'
        },
      );

      if (res.statusCode == 200) {
        // La réponse est une liste JSON, nous la décodons.
        final List<dynamic> jsonList = jsonDecode(res.body);
        
        // Mappage de la liste JSON en une liste d'objets Campo
        return jsonList.map((json) => Campo.fromJson(json)).toList();
      } else {
        // Gérer les erreurs HTTP (404, 500, etc.)
        throw Exception('Échec du chargement des terrains. Code: ${res.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou de décodage
      throw Exception('Erreur de connexion : $e');
    }
  }
}