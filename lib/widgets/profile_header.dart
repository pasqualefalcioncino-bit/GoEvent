import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/user.dart';

// Header del profilo
class ProfileHeader extends StatelessWidget {
  final User user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    // Controlla se l'utente ha un'immagine di profilo salvata
    final hasImage = user.immagineProfilo != null &&
        File(user.immagineProfilo!).existsSync();

    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            child: FadeInDown(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: hasImage
                    ? FileImage(File(user.immagineProfilo!))
                    : const AssetImage('assets/images/profile_default.jpg')
                as ImageProvider,
              ),
            ),
          ),

          // Nome e email dell'utente
          Positioned(
            bottom: 35,
            child: FadeInUp(
              child: Column(
                children: [

                  // Nome e cognome se non presenti
                  Text(
                    '${user.nome.isNotEmpty ? user.nome : "Nome"} '
                        '${user.cognome.isNotEmpty ? user.cognome : "Cognome"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Email con se non impostata
                  Text(
                    user.email.isNotEmpty ? user.email : "Email non impostata",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
