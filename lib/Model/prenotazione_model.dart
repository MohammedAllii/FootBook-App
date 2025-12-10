import 'package:footbookcamp/Model/campi_model.dart';

class Prenotazione {
  final int id;
  final int campiId;
  final int userId;
  final String data;
  final String ora;
  final double prezzo;
  final Campo? campo; 

  Prenotazione({
    required this.id,
    required this.campiId,
    required this.userId,
    required this.data,
    required this.ora,
    required this.prezzo,
    this.campo,
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'],
      campiId: json['campi_id'],
      userId: json['user_id'],
      data: json['data'],
      ora: json['ora'],
      prezzo: (json['prezzo'] as num).toDouble(),
      campo: json['campo'] != null ? Campo.fromJson(json['campo']) : null,
    );
  }
}
