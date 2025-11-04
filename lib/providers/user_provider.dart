import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

// Provider per gestire il profilo utente
class UserProvider extends ChangeNotifier {

  // Variabile interna per utente corrente
  late User _user;

  // Per salvare i dati dell'utente
  final _box = Hive.box('userBox');

  // Per accedere all'utente corrente
  User get user => _user;

  // Carica il profilo utente dalla box Hive se non c'è inizializzza un profilo nuovo
  void caricaProfilo() {
    final data = _box.get('user');
    if (data != null) {
      _user = User.fromMap(Map<String, dynamic>.from(data));
    } else {
      _user = User(nome: '', cognome: '', email: '', dataNascita: '');
    }
  }

  // Aggiorna il profilo utente completo
  Future<void> aggiornaProfilo(User nuovo) async {
    _user = nuovo;
    await _box.put('user', nuovo.toMap());
    notifyListeners();
  }

  // Aggiorna solo l'immagine del profilo
  Future<void> aggiornaImmagineProfilo(String path) async {
    _user = User(
      nome: _user.nome,
      cognome: _user.cognome,
      email: _user.email,
      dataNascita: _user.dataNascita,
      immagineProfilo: path,
    );
    await _box.put('user', _user.toMap());
    notifyListeners();
  }
}
