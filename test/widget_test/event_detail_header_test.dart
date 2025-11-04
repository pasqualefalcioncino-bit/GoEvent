import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_event/widgets/event_detail_header.dart';
import 'package:go_event/models/event.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('EventDetailHeader Tests', () {

    final testEvent = Event(
      id: '1',
      name: 'Concerto Rock',
      date: '2025-12-25',
      city: 'Roma',
      venue: 'Stadio Olimpico',
      imageUrl: 'https://example.com/image.jpg',
    );

    testWidgets('deve mostrare titolo evento', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDetailHeader(event: testEvent),
            ),
          ),
        );

        // Aspetta la fine delle animazioni
        await tester.pumpAndSettle();
      });

      // Verifica titolo
      expect(find.text('Concerto Rock'), findsOneWidget);
    });

    // Presenza immagine
    testWidgets('deve avere immagine', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDetailHeader(event: testEvent),
            ),
          ),
        );

        await tester.pumpAndSettle();
      });

      expect(find.byType(Hero), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    // Stile testo
    testWidgets('titolo deve essere bianco e grassetto', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDetailHeader(event: testEvent),
            ),
          ),
        );

        await tester.pumpAndSettle();
      });

      final textWidget = tester.widget<Text>(find.text('Concerto Rock'));
      expect(textWidget.style?.color, Colors.white);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}