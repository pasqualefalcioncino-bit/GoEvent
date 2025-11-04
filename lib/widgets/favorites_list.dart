import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/event.dart';
import '../screens/detail_screen.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';

// Lista di eventi preferiti
class FavoritesList extends StatelessWidget {
  final List<Event> favorites;

  const FavoritesList({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final e = favorites[index];

        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(

              // Immagine evento
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: e.imageUrl != null
                    ? Image.network(
                  e.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),

              // Titolo e sottotitolo
              title: Text(
                e.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${e.city ?? "-"} • ${e.date ?? "-"}'),

              // Pulsante per preferiti
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => provider.toggleFavorite(e),
              ),

              // Click per aprire dettaglio evento
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(event: e)),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
