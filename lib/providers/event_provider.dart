import 'package:flutter/material.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../utils/location_service.dart';
import '../utils/network_service.dart';
import 'favorites_provider.dart';

// Provider principale per la gestione degli eventi
class EventProvider with ChangeNotifier {

  // Repository per recuperare eventi
  final EventRepository repository = EventRepository();

  // Ottiene la posizione GPS dell'utente
  final LocationService locationService = LocationService();

  // Provider degli eventi preferiti
  FavoritesProvider favoritesProvider;

  // Aggiorna automaticamente gli eventi preferiti
  EventProvider({required this.favoritesProvider}) {
    favoritesProvider.addListener(onFavoritesChanged);
  }


  List<Event> _allEvents = [];

  bool loading = false;

  // Flag che indica se l'app è in modalità offline (db locale) o online (API)
  bool offlineMode = false;

  String? errorMessage;

  // Filtri
  String? cityFilter;
  DateTime? dateFilter;

  // Mostra solo eventi preferiti
  bool showFavoritesOnly = false;

  // Restituisce eventi in base ai filtri attivi
  List<Event> get events {
    return _allEvents.where((event) {

      final matchesCity = cityFilter == null || event.city == cityFilter;

      final eventDate = DateTime.tryParse(event.date);

      final matchesDate = dateFilter == null
          ? true
          : (eventDate != null &&
          eventDate.year == dateFilter!.year &&
          eventDate.month == dateFilter!.month &&
          eventDate.day == dateFilter!.day);

      final matchesFavorite = !showFavoritesOnly || favoritesProvider.isFavorite(event);

      return matchesCity && matchesDate && matchesFavorite;
    }).toList();
  }

  // Restituisce tutti gli eventi senza filtri

  List<Event> get allEvents => _allEvents;


  // Carica gli eventi
  Future<void> loadEvents() async {
    loading = true;
    errorMessage = null;
    offlineMode = false;
    notifyListeners();

    try {

      // Verifica connessione internet
      final hasInternet = await NetworkService.hasConnection();

      // Ottiene posizione GPS dell'utente
      final position = await locationService.getCurrentPosition();
      if (position == null) {
        throw Exception("Impossibile ottenere la posizione.");
      }

      // Carica eventi in base alla connessione
      if (hasInternet) {
        // Se online scarica da API Ticketmaster
        _allEvents = await repository.fetchEvents(
          position.latitude,
          position.longitude,
        );
      } else {
        // Se offline carica da Hive
        _allEvents = await repository.getLocalEvents();
        offlineMode = true;

        if (_allEvents.isEmpty) {
          // Se locale vuota, lancia eccezione
          throw Exception("Nessun evento disponibile offline.");
        }
      }

    } catch (e) {
      // Prova a caricare da cache locale
      _allEvents = await repository.getLocalEvents();

      if (_allEvents.isNotEmpty) {
        // Se locale ha dati, entra in modalità offline
        offlineMode = true;
        errorMessage = "Connessione assente — modalità offline attiva.";
      } else {
        // Se nemmeno locale ha dati, mostra errore
        errorMessage = e.toString();
      }
    }

    // Sincronizza stato preferiti e aggiorna UI
    _syncFavoritesState();
    loading = false;
    notifyListeners();
  }

  // Sincronizza lo stato dei preferiti sugli eventi caricati
  void _syncFavoritesState() {
    for (var e in _allEvents) {
      e.isFavorite = favoritesProvider.isFavorite(e);
    }
  }

  // Ri-sincronizza stato preferiti
  void onFavoritesChanged() {
    _syncFavoritesState();
    notifyListeners();
  }

  // Aggiunge/rimuove da preferiti
  void toggleFavorite(Event event) {
    favoritesProvider.toggleFavorite(event);
    _syncFavoritesState();
    notifyListeners();
  }

  // Filtro città
  void setCityFilter(String? city) {
    cityFilter = city;
    notifyListeners();
  }

  // Filtro data
  void setDateFilter(DateTime? date) {
    dateFilter = date;
    notifyListeners();
  }

  // Filtro viisualizzazione solo preferiti
  void toggleShowFavorites(bool value) {
    showFavoritesOnly = value;
    notifyListeners();
  }

  // Resetta tutti i filtri
  void clearFilters() {
    cityFilter = null;
    dateFilter = null;
    showFavoritesOnly = false;
    notifyListeners();
  }

  // Rimuove il listener per evitare memory leak
  @override
  void dispose() {
    favoritesProvider.removeListener(onFavoritesChanged);
    super.dispose();
  }

  // Metodo usato per i test
  @visibleForTesting
  void setEventsForTesting(List<Event> events) {
    _allEvents = events;
  }

}