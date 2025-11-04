import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_event/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();
    await Hive.openBox('favoritesBox');
    await Hive.openBox('userBox');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('Avvio app, navigazione tab, apertura dettaglio evento', (tester) async {

    // Avvia l'app
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verifica titolo GoEvent
    expect(find.text('GoEvent'), findsOneWidget);

    // Verifica presenza della BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Naviga tra le tab
    final tabs = ['Mappa', 'Preferiti', 'Profilo', 'Home'];
    for (final tab in tabs) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
    }

    // Verifica presenza eventi
    final hasEventCard = find.byType(Card).evaluate().isNotEmpty;
    final hasMessage = find.textContaining('Nessun evento').evaluate().isNotEmpty;

    expect(hasEventCard || hasMessage, isTrue);

    // Se ci sono eventi, apri il dettaglio
    if (hasEventCard) {
      final firstCard = find.byType(Card).first;
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      expect(find.textContaining('Data'), findsOneWidget);
      expect(find.textContaining('Città'), findsOneWidget);
      expect(find.textContaining('Luogo'), findsOneWidget);
    }
  });
}
