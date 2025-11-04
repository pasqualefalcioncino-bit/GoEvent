import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/event_provider.dart';
import '../widgets/map_view.dart';
import 'package:flutter_map/flutter_map.dart';

// Schermata della mappa eventi
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  // Sposta la mappa sulla posizione dell'utente
  Future<void> _getCurrentLocation() async {

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Servizi di localizzazione disattivati')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();

      final newPosition = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _currentPosition = newPosition;
      });

      // Muove la mappa alla posizione corrente
      _mapController.move(newPosition, 13);

  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("Mappa Eventi"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: MapView(
        mapController: _mapController,
        events: events,
        currentPosition: _currentPosition,
        onRefreshLocation: _getCurrentLocation,
      ),
    );
  }
}
