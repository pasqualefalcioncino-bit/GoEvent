import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../screens/detail_screen.dart';

// Card che mostra informazioni di un singolo evento
class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {

        // Controlla se l'evento è tra i preferiti
        final isFav = eventProvider.favoritesProvider.isFavorite(event);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(

            // Mostra immagine dell'evento, fallback icona se non disponibile
            leading: (event.imageUrl.isNotEmpty)
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                event.imageUrl,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.event),
              ),
            )
                : const Icon(Icons.event),

            // Titolo e sottotitolo dell'evento
            title: Text(event.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${event.city} - ${event.date}'),

            // Pulsante preferito
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => eventProvider.toggleFavorite(event),
            ),

            // Azione quando clicco sulla card
            onTap: onTap ??
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailScreen(event: event)),
                  );
                },
          ),
        );
      },
    );
  }
}
