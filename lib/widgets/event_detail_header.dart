import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:animate_do/animate_do.dart';

// Header della schermata dettagli evento
class EventDetailHeader extends StatelessWidget {
  final Event event;
  const EventDetailHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // Immagine dell'evento
        Hero(
          tag: event.name,
          child: Image.network(
            event.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Container(
          height: 250,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
        ),

        // Titolo dell'evento
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: FadeInUp(
            child: Text(
              event.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
