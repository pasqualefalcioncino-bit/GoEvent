import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_list.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/home_header.dart';
import 'detail_screen.dart';
import 'package:animate_do/animate_do.dart';

// Schermata home dell'app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Carica eventi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [

          // Bottone per aprire il filtro
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.deepPurple),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => FilterSheet(provider: provider),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const HomeHeader(),

          // Banner per indicare se siamo offline o se ci sono errori
          if (provider.offlineMode || provider.errorMessage != null)
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: double.infinity,
                color: provider.offlineMode
                    ? Colors.orange.shade700
                    : Colors.redAccent.shade400,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      provider.offlineMode
                          ? Icons.wifi_off_rounded
                          : Icons.error_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        provider.errorMessage ??
                            "Connessione assente — modalità offline attiva.",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Lista eventi, caricamento o messaggi di errore
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.events.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_busy,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      provider.offlineMode
                          ? "Nessun evento disponibile offline"
                          : "Nessun evento trovato",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : EventList(
                events: provider.events,
                onTap: (event) {

                  // Navigazione alla schermata di dettaglio evento
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          DetailScreen(event: event),
                      transitionsBuilder: (_, anim, __, child) =>
                          FadeTransition(opacity: anim, child: child),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottone per refreshare gli eventi
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: provider.loadEvents,
      ),
    );
  }
}
