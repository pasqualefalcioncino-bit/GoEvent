import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/event.dart';

// Servizio per comunicare con l’API di Ticketmaster
class TicketmasterApi {
  // Legge la chiave API dal file .env
  String get apiKey => dotenv.env['TICKETMASTER_API_KEY'] ?? '';

  // Restituisce una lista di oggetti Event
  Future<List<Event>> getEvents(double latitude, double longitude) async {
    if (apiKey.isEmpty) {
      return [];
    }

    final url = 'https://app.ticketmaster.com/discovery/v2/events.json?latlong=$latitude,$longitude&radius=800&apikey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Estrae gli eventi dalla risposta
        final eventsJson = data['_embedded']?['events'] as List?;

        if (eventsJson != null) {
          // Mappa la lista JSON in oggetti Event
          return eventsJson.map((e) => Event.fromJson(e)).toList();
        }
      }

    return []; // Se fallisce, restituisce lista vuota
  }
}
