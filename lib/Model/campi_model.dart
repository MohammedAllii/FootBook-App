class Campo {
  final int id;
  final String nome;
  final String descrizione;
  final String tipo;
  final List<String> servizi;
  final String email;
  final String telefono;
  final double recensione;
  final String localita;
  final double latitude;
  final double longitude;
  final List<String> foto;
  
  // Constructeur
  Campo({
    required this.id,
    required this.nome,
    required this.descrizione,
    required this.tipo,
    required this.servizi,
    required this.email,
    required this.telefono,
    required this.recensione,
    required this.localita,
    required this.latitude,
    required this.longitude,
    required this.foto,
  });

  // Factory method pour créer un objet Campo à partir d'un Map JSON
  factory Campo.fromJson(Map<String, dynamic> json) {
    // Le JSON retourne recensione parfois comme un int (4) et parfois comme un double (4.5), 
    // on s'assure qu'il est toujours traité comme un double.
    double recensioneValue;
    if (json['recensione'] is int) {
      recensioneValue = (json['recensione'] as int).toDouble();
    } else {
      recensioneValue = json['recensione'] as double;
    }

    return Campo(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      tipo: json['tipo'] as String,
      // Conversion des List<dynamic> JSON en List<String> Dart
      servizi: List<String>.from(json['servizi'] as List),
      email: json['email'] as String,
      telefono: json['telefono'] as String,
      recensione: recensioneValue,
      localita: json['localita'] as String,
      // S'assurer que les coordonnées sont des doubles
      latitude: (json['latitudine'] as num).toDouble(),
      longitude: (json['longitudine'] as num).toDouble(),
      // Conversion des List<dynamic> JSON en List<String> Dart pour les URLs des photos
      foto: List<String>.from(json['foto'] as List),
    );
  }
}