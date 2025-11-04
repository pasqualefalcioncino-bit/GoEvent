import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';

// Provider per gestire i preferiti degli eventi
class FavoritesProvider extends ChangeNotifier {

  // Accesso ad Hive che contiene i preferiti
  final Box favoritesBox = Hive.box('favoritesBox');

  // Si ottiene la lista di eventi salvati localmente
  List<Event> get favorites {
    final List stored = favoritesBox.get('events', defaultValue: []) as List;

    // Converte ogni elemento salvato in un oggetto Event
    return stored
        .map((e) => Event.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Controlla se un evento è nei preferiti
  bool isFavorite(Event event) {
    return favorites.any((e) => e.id == event.id);
  }

  // Aggiunge o rimuove un evento dai preferiti
  void toggleFavorite(Event event) {
    final List current = favoritesBox.get('events', defaultValue: []) as List;

    if (isFavorite(event)) {
      current.removeWhere((e) => e['id'] == event.id);
    } else {
      current.add(event.toMap());
    }

    // Aggiorna Hive con la nuova lista
    favoritesBox.put('events', current);

    // Notifica tutti i widget che stanno ascoltando questo provider
    notifyListeners();
  }

}
