import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_card.dart';

// Lista di eventi
class EventList extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onTap;

  const EventList({super.key, required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: events[index],
          onTap: () => onTap(events[index]),
        );
      },
    );
  }
}
