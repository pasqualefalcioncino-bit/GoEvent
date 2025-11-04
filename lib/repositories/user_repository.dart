import 'package:hive/hive.dart';
import '../models/user.dart';

// Repository per gestire i dati dell'utente
class UserRepository {
  static const String boxName = 'userBox';

  // Salva i dati dell’utente in Hive
  Future<void> salvaUser(User user) async {
    final box = await Hive.openBox(boxName);
    await box.put('user', user.toMap());
  }

  // Carica i dati dell’utente da Hive
  Future<User> caricaUser() async {
    final box = await Hive.openBox(boxName);
    final data = box.get('user');

    if (data == null) return User.vuoto(); // Se non ci sono dati, ritorna profilo vuoto

    return User.fromMap(Map<String, dynamic>.from(data));
  }

  // Elimina completamente i dati del profilo
  Future<void> cancellaUser() async {
    final box = await Hive.openBox(boxName);
    await box.delete('user');
  }
}
