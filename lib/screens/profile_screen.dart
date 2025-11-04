import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/edit_profile_screen.dart';
import '../widgets/profile_header.dart';

// Schermata del profilo utente
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          'Profilo Utente',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [

          ProfileHeader(user: user),

          const SizedBox(height: 20),

          // Lista info e pulsanti
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [

                // Card per data di nascita
                _buildInfoCard(
                  icon: Icons.cake,
                  label: "Data di nascita",
                  value: user.dataNascita.isNotEmpty
                      ? user.dataNascita
                      : "Non impostata",
                ),
                const SizedBox(height: 12),

                // Card per email
                _buildInfoCard(
                  icon: Icons.email,
                  label: "Email",
                  value: user.email.isNotEmpty
                      ? user.email
                      : "Nessuna email salvata",
                ),
                const SizedBox(height: 24),

                // Bottoni Modifica
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Modifica profilo
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F00FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditProfileScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Modifica',
                          style: TextStyle(color: Colors.white)),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mostrare info come card
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7F00FF)),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(value),
      ),
    );
  }
}
