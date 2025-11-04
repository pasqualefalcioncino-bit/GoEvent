// Data Model che rappresenta un evento
class Event {
  final String id;
  final String name;
  final String date;
  final String city;
  final String venue;
  final String imageUrl;
  final double? latitude;
  final double? longitude;
  final String? url;

  // Flag evento tra i preferiti
  bool isFavorite;

  // Costruttore principale
  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.city,
    required this.venue,
    required this.imageUrl,
    this.latitude,
    this.longitude,
    this.isFavorite = false,
    this.url,
  });

  // Estrazione dati in struttura JSON
  factory Event.fromJson(Map<String, dynamic> json) {

    final venue = json['_embedded']?['venues']?[0];
    final location = venue?['location'];

    return Event(

      id: json['id'] ?? '',
      name: json['name'] ?? 'Evento sconosciuto',
      date: json['dates']?['start']?['localDate'] ?? 'Data non disponibile',
      city: venue?['city']?['name'] ?? 'Città sconosciuta',
      venue: venue?['name'] ?? 'Luogo sconosciuto',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)  ? json['images'][0]['url'] : '',
      url: json['url'] ?? '',

      latitude: location != null ? double.tryParse(location['latitude'] ?? '0') : null,
      longitude: location != null ? double.tryParse(location['longitude'] ?? '0') : null,

      isFavorite: false,

    );
  }

  // Crea un Event da una mappa (usato per Hive)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Evento sconosciuto',
      date: map['date'] ?? 'Data non disponibile',
      city: map['city'] ?? 'Città sconosciuta',
      venue: map['venue'] ?? 'Luogo sconosciuto',
      imageUrl: map['imageUrl'] ?? '',
      url: map['url'] ?? '',

      latitude: map['latitude'] != null ? map['latitude'].toDouble() : null,
      longitude: map['longitude'] != null ? map['longitude'].toDouble() : null,

      isFavorite: map['isFavorite'] ?? false,

    );
  }

  // Converte l'oggetto Event in una mappa usato per salvare su Hive o passare dati tra schermate
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'city': city,
      'venue': venue,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorite': isFavorite,
      'url': url
    };
  }
}
