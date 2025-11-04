import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../providers/favorites_provider.dart';
import 'package:animate_do/animate_do.dart';

// Mostra le informazioni dettagliate di un evento
class EventDetailInfo extends StatelessWidget {
  final Event event;
  const EventDetailInfo({super.key, required this.event});

  // Apre il sito del biglietto nel browser
  Future<void> _openTicketUrl(BuildContext context) async {
    final urlString = event.url ?? 'https://www.ticketmaster.it';
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile aprire il link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [

            // Contenuto principale
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.event, 'Data', event.date),
                _buildInfoRow(Icons.location_city, 'Città', event.city),
                _buildInfoRow(Icons.place, 'Luogo', event.venue),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _openTicketUrl(context),
                    icon: const Icon(Icons.confirmation_num_outlined),
                    label: const Text(
                      'Vai al sito Ticket',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // Icona per mettere come preferito l'evento
            Positioned(
              top: 0,
              right: 0,
              child: Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, _) {
                  final isFav = favoritesProvider.isFavorite(event);

                  return IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFav),
                        color: isFav ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                    ),
                    tooltip:
                    isFav ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
                    onPressed: () {
                      favoritesProvider.toggleFavorite(event);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? 'Rimosso dai preferiti'
                                : 'Aggiunto ai preferiti',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Righe con icona, etichetta e valore
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
