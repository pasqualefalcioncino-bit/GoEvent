import 'package:hive/hive.dart';
import '../models/event.dart';
import '../services/ticketmaster_api.dart';
import '../utils/network_service.dart';

// Repository per gestire gli eventi
class EventRepository {
  final TicketmasterApi api = TicketmasterApi();
  final String hiveBoxName = 'eventsBox';

  // Recupera eventi su locale
  Future<List<Event>> fetchEvents(double latitude, double longitude) async {
    final bool isConnected = await NetworkService.hasConnection();

    // Se online scarica dati da API
    if (isConnected) {
      try {
        final List<Event> events = await api.getEvents(latitude, longitude);

        if (events.isNotEmpty) {
          // Salva in cache per uso offline
          await _saveToCache(events);

          return events;
        } else {
          return await _loadFromCache();
        }
      } catch (e) {
        // Errore su API carica da locale
        return await _loadFromCache();
      }
    }

    // Se ogfline carica da locale
    return await _loadFromCache();
  }

  // Salva eventi in Hive
  Future<void> _saveToCache(List<Event> events) async {
    try {
      final box = await Hive.openBox(hiveBoxName);
      await box.put('events', events.map((e) => e.toMap()).toList());
      await box.put('lastUpdate', DateTime.now().toIso8601String());
    } catch (e) {
      print(' Errore salvataggio in locale: $e');
    }
  }

  // Carica eventi da Hive
  Future<List<Event>> _loadFromCache() async {
    try {
      final box = await Hive.openBox(hiveBoxName);
      final List<dynamic>? cachedData = box.get('events');

      if (cachedData == null || cachedData.isEmpty) {
        throw Exception('Nessun evento disponibile offline');
      }


      return cachedData
          .map((e) => Event.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception('Impossibile caricare eventi offline');
    }
  }

  // Recupera eventi locali per provider
  Future<List<Event>> getLocalEvents() async {
    return await _loadFromCache();
  }
}