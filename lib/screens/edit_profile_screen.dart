import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_header.dart';

// Schermata per modificare il profilo utente
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _immagineSelezionata;

  // Controller per i campi di input
  late TextEditingController nomeController;
  late TextEditingController cognomeController;
  late TextEditingController emailController;
  late TextEditingController dataController;

  @override
  void initState() {
    super.initState();
    // Recupera i dati dell'utente dal provider
    final user = context.read<UserProvider>().user;
    nomeController = TextEditingController(text: user.nome);
    cognomeController = TextEditingController(text: user.cognome);
    emailController = TextEditingController(text: user.email);
    dataController = TextEditingController(text: user.dataNascita);

    // Carica immagine profilo
    if (user.immagineProfilo != null && user.immagineProfilo!.isNotEmpty) {
      _immagineSelezionata = File(user.immagineProfilo!);
    }
  }

  // Permette di scegliere un'immagine da galleria o scattarla con fotocamera
  Future<void> _scegliImmagine(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _immagineSelezionata = File(pickedFile.path);
      });
    }
  }

  // Mostra un picker per selezionare la data di nascita
  Future<void> _selezionaData() async {
    final dataScelta = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dataScelta != null) {
      dataController.text =
      "${dataScelta.day}/${dataScelta.month}/${dataScelta.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Modifica Profilo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              ProfileHeader(user: user),

              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _mostraBottomSheet,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF7F00FF),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Form per modificare dati
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      controller: nomeController,
                      label: 'Nome',
                      validator: (v) =>
                      v!.isEmpty ? 'Inserisci il nome' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: cognomeController,
                      label: 'Cognome',
                      validator: (v) =>
                      v!.isEmpty ? 'Inserisci il cognome' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                      v!.contains('@') ? null : 'Email non valida',
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: dataController,
                      label: 'Data di nascita',
                      readOnly: true,
                      onTap: _selezionaData,
                    ),
                    const SizedBox(height: 24),

                    // Pulsante salva modifiche
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F00FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final nuovoUser = User(
                            nome: nomeController.text,
                            cognome: cognomeController.text,
                            email: emailController.text,
                            dataNascita: dataController.text,
                            immagineProfilo: _immagineSelezionata?.path,
                          );

                          // Aggiorna il profilo tramite provider
                          await context
                              .read<UserProvider>()
                              .aggiornaProfilo(nuovoUser);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Salva modifiche',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Costruisce un campo di input riutilizzabile
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    void Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF7F00FF), width: 2),
        ),
      ),
    );
  }

  // Scelta tra camera o galleria
  void _mostraBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _buildBottomSheet(),
    );
  }

  // Per la scelta dell'immagine
  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 150,
      child: Column(
        children: [
          const Text(
            'Cambia immagine profilo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F00FF),
                ),
                onPressed: () => _scegliImmagine(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('Fotocamera',
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                ),
                onPressed: () => _scegliImmagine(ImageSource.gallery),
                icon: const Icon(Icons.photo, color: Colors.white),
                label:
                const Text('Galleria', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
