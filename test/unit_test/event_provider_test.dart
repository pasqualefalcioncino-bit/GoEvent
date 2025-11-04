import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:go_event/providers/event_provider.dart';
import 'package:go_event/providers/favorites_provider.dart';
import 'package:go_event/models/event.dart';

void main() {
  group('EventProvider Tests', () {
    late EventProvider provider;
    late FavoritesProvider favProvider;

    // Inizializza Hive prima di tutti i test
    setUpAll(() async {
      await setUpTestHive();
    });

    // Pulisci Hive alla fine dei test
    tearDownAll(() async {
      await tearDownTestHive();
    });

    setUp(() async {
      await Hive.openBox('favoritesBox');

      favProvider = FavoritesProvider();
      provider = EventProvider(favoritesProvider: favProvider);
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('favoritesBox');
    });

    // Test filtro città
    test('Deve filtrare eventi per città', () {
      final eventi = [
        Event(id: '1', name: 'Evento Roma', date: '2025-12-25',
            city: 'Roma', venue: 'Venue 1', imageUrl: ''),
        Event(id: '2', name: 'Evento Milano', date: '2025-12-25',
            city: 'Milano', venue: 'Venue 2', imageUrl: ''),
      ];

      provider.setEventsForTesting(eventi);
      provider.setCityFilter('Roma');

      expect(provider.events.length, 1);
      expect(provider.events[0].city, 'Roma');
    });

    // Filtro data
    test('Deve filtrare eventi per data', () {
      final eventi = [
        Event(id: '1', name: 'Evento 25', date: '2025-12-25',
            city: 'Roma', venue: 'Venue', imageUrl: ''),
        Event(id: '2', name: 'Evento 26', date: '2025-12-26',
            city: 'Roma', venue: 'Venue', imageUrl: ''),
      ];

      provider.setEventsForTesting(eventi);
      provider.setDateFilter(DateTime(2025, 12, 25));

      expect(provider.events.length, 1);
      expect(provider.events[0].name, 'Evento 25');
    });

    // Reset filtri
    test('Deve rimuovere tutti i filtri', () {

      provider.setCityFilter('Roma');
      provider.setDateFilter(DateTime(2025, 12, 25));
      provider.clearFilters();

      expect(provider.cityFilter, null);
      expect(provider.dateFilter, null);
    });
  });
}