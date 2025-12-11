import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:footbookcamp/Model/prenotazione_model.dart';

class ReservationService {
  final String baseUrl = "http://10.109.162.110:8000/api";

  Future<Prenotazione?> getTodayNextReservation(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/today-next-reservation?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Laravel renvoie: { status: true, reservation: {...} }
        final reservationData = data['reservation'];

        if (reservationData == null) {
          return null;
        }

        return Prenotazione.fromJson(reservationData);
      } else {
        print("Erreur code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erreur API: $e");
      return null;
    }
  }

    // --- récupérer toutes les réservations d'un utilisateur
  Future<List<Prenotazione>> getUserReservations(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-reservations?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List reservationsData = data['reservations'] ?? [];

        return reservationsData
            .map((r) => Prenotazione.fromJson(r))
            .toList();
      } else {
        print("Erreur code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erreur API: $e");
      return [];
    }
  }
}
