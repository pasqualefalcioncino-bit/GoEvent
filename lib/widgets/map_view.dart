import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:animate_do/animate_do.dart';
import '../models/event.dart';
import '../screens/detail_screen.dart';

// Gestisce la parte grafica della mappa eventi
class MapView extends StatelessWidget {
  final List<Event> events;
  final LatLng? currentPosition;
  final VoidCallback onRefreshLocation;
  final MapController mapController;

  const MapView({
    super.key,
    required this.events,
    required this.currentPosition,
    required this.onRefreshLocation,
    required this.mapController,
  });

  // Mostra gli eventi di una città
  void _showEventSheet(BuildContext context, String city, List<Event> events) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                events.length == 1 ? events.first.name : 'Eventi a $city',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 10),
              ...events.map((e) => ListTile(
                leading: Icon(
                  e.isFavorite ? Icons.favorite : Icons.event,
                  color: e.isFavorite
                      ? Colors.pinkAccent
                      : const Color(0xFF6D28D9),
                ),
                title: Text(e.name),
                subtitle: Text('${e.venue} - ${e.date}'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(event: e),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialCenter = currentPosition ??
        (events.isNotEmpty &&
            events.first.latitude != null &&
            events.first.longitude != null
            ? LatLng(events.first.latitude!, events.first.longitude!)
            : const LatLng(41.28, 14.43));

    // Raggruppa eventi per città
    final Map<String, List<Event>> eventsByCity = {};
    for (var e in events) {
      if (e.city != null && e.latitude != null && e.longitude != null) {
        eventsByCity.putIfAbsent(e.city!, () => []).add(e);
      }
    }

    // Crea i markers
    final List<Marker> markers = [];
    eventsByCity.forEach((city, cityEvents) {
      final Event firstEvent = cityEvents.first;
      markers.add(
        Marker(
          point: LatLng(firstEvent.latitude!, firstEvent.longitude!),
          width: 38,
          height: 38,
          child: BounceInDown(
            duration: const Duration(milliseconds: 700),
            child: GestureDetector(
              onTap: () => _showEventSheet(context, city, cityEvents),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: cityEvents.any((e) => e.isFavorite)
                        ? [Colors.pinkAccent, Colors.orangeAccent]
                        : [const Color(0xFF6D28D9), const Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 22),
              ),
            ),
          ),
        ),
      );
    });

    return Stack(
      children: [

        // Mappa principale
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.go_event',
            ),
            MarkerLayer(markers: markers),
            if (currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPosition!,
                    width: 42,
                    height: 42,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        ),
                      ),
                      child: const Icon(Icons.my_location,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
          ],
        ),

        // Barra di ricerca delle città disponibili
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 14,
          right: 14,
          child: FadeInDown(
            child: Card(
              color: Colors.white,
              elevation: 10,
              shadowColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: TypeAheadField<String>(
                suggestionsCallback: (pattern) {
                  return eventsByCity.keys
                      .where((city) =>
                      city.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.location_city,
                        color: Color(0xFF6D28D9)),
                    title: Text(suggestion),
                  );
                },
                onSelected: (city) {
                  final cityEvents = eventsByCity[city];
                  if (cityEvents != null && cityEvents.isNotEmpty) {
                    final e = cityEvents.first;
                    mapController.move(LatLng(e.latitude!, e.longitude!), 13);
                  }
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Cerca una città...',
                      contentPadding: EdgeInsets.all(14),
                      border: InputBorder.none,
                      prefixIcon:
                      Icon(Icons.search, color: Color(0xFF6D28D9)),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Bottone centra posizione
        Positioned(
          bottom: 24,
          right: 24,
          child: GlowButton(onPressed: onRefreshLocation),
        ),

        // Legenda
        Positioned(
          bottom: 24,
          left: 16,
          child: FadeInUp(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on,
                      color: Color(0xFF6D28D9), size: 18),
                  SizedBox(width: 6),
                  Text('Evento'),
                  SizedBox(width: 12),
                  Icon(Icons.favorite, color: Colors.pinkAccent, size: 18),
                  SizedBox(width: 6),
                  Text('Preferito'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Bottone con effetto
class GlowButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GlowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent,
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: onPressed,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
