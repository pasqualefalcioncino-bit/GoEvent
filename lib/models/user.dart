// Data Model che rappresenta un utente
class User {
  final String nome;
  final String cognome;
  final String email;
  final String dataNascita;
  final String? immagineProfilo; // opzionale

  // Costruttore principale
  User({
    required this.nome,
    required this.cognome,
    required this.email,
    required this.dataNascita,
    this.immagineProfilo,
  });

  // Crea un utente "vuoto"
  factory User.vuoto() => User(
    nome: '',
    cognome: '',
    email: '',
    dataNascita: '',
    immagineProfilo: null,
  );

  // Salva i dati su Hive
  Map<String, dynamic> toMap() => {
    'nome': nome,
    'cognome': cognome,
    'email': email,
    'dataNascita': dataNascita,
    'immagineProfilo': immagineProfilo,
  };

  // Ricostruisce un oggetto User dalla mappa
  factory User.fromMap(Map<String, dynamic> map) => User(
    nome: map['nome'] ?? '',
    cognome: map['cognome'] ?? '',
    email: map['email'] ?? '',
    dataNascita: map['dataNascita'] ?? '',
    immagineProfilo: map['immagineProfilo'],
  );
}
