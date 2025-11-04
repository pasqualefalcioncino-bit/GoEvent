import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorites_header.dart';
import '../widgets/favorites_list.dart';

// Schermata degli eventi preferiti
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Recupera il provider dei preferiti
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const FavoritesHeader(),
          Expanded(
            child: favorites.isEmpty
                ? const Center(
              child: Text(
                'Nessun evento nei preferiti',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : FavoritesList(favorites: favorites),
          ),
        ],
      ),
    );
  }
}
