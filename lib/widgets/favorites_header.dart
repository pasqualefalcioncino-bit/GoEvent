import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

// Header della schermata preferiti
class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7F00FF),
            Color(0xFFE100FF),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
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
        children: [

          // Titolo principale
          Positioned(
            left: 20,
            bottom: 30,
            child: FadeInDown(
              child: const Text(
                "I tuoi eventi preferiti",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          // Icona sullo sfondo
          Positioned(
            right: -40,
            top: -20,
            child: FadeInRight(
              duration: const Duration(milliseconds: 800),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 140,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
