import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Servizio per gestire la posizione dell’utente
class LocationService {

  Future<Position?> getCurrentPosition() async {

    // Richiedi permessi per la posizione
    if (await Permission.location.request().isDenied) {
      return null;
    }

    // Controlla se il GPS è attivo
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    // Ottieni la posizione corrente
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
