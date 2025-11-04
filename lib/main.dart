import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'providers/event_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/user_provider.dart';

// Screens
import 'screens/main_screen.dart';

// Classe Main
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Legge e salva l'API dal file .env
  await dotenv.load(fileName: ".env");

  // Inizializzazione Hive per la persistenza locale
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');
  await Hive.openBox('userBox');

  // Configura i Provider
  runApp(
    MultiProvider(
      providers: [

        // Provider per i preferiti
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),

        // Provider per gli eventi
        ChangeNotifierProxyProvider<FavoritesProvider, EventProvider>(
          create: (context) {
            final fav = context.read<FavoritesProvider>();
            return EventProvider(favoritesProvider: fav);
          },
          update: (context, favorites, previous) {

            // Rimuove listener per evitare duplicazioni
            previous?.favoritesProvider.removeListener(previous.onFavoritesChanged);

            // Aggiorna il provider
            previous?.favoritesProvider = favorites;

            // Aggiunge listener per aggiornamenti automatici
            favorites.addListener(previous!.onFavoritesChanged);

            return previous;
          },
        ),

        // Provider per l’utente
        ChangeNotifierProvider(create: (_) => UserProvider()..caricaProfilo()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoEvent',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MainNavigation(), // Schermata principale con BottomNavigation
    );
  }
}
