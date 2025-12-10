import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:footbookcamp/Model/prenotazione_model.dart';

class ReservationService {
  final String baseUrl = "http://10.109.162.110:8000/api";

  Future<Prenotazione?> getTodayNextReservation(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/today-next-reservation'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reservations = data['reservations'] as List;

        if (reservations.isEmpty) return null;

        // Filtrer par utilisateur
        final userReservations = reservations
            .where((r) => r['user_id'] == userId)
            .toList();

        if (userReservations.isEmpty) return null;

        // Trier par heure et prendre la prochaine réservation
        userReservations.sort((a, b) {
          final dateTimeA = DateTime.parse("${a['data']} ${a['ora']}:00");
          final dateTimeB = DateTime.parse("${b['data']} ${b['ora']}:00");
          return dateTimeA.compareTo(dateTimeB);
        });

        final now = DateTime.now();
        final nextReservation = userReservations.firstWhere(
            (r) => DateTime.parse("${r['data']} ${r['ora']}:00").isAfter(now),
            orElse: () => null); // orElse ne peut pas retourner null → on gère après

        if (nextReservation == null) return null;

        return Prenotazione.fromJson(nextReservation);
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur API: $e");
      return null;
    }
  }
}
