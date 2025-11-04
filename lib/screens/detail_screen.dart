import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_detail_header.dart';
import '../widgets/event_detail_info.dart';

// Schermata di dettaglio di un evento
class DetailScreen extends StatelessWidget {
  final Event event;
  const DetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true, // Rimane visibile quando si scorre
            flexibleSpace: FlexibleSpaceBar(
              background: EventDetailHeader(event: event),
            ),
          ),

          // Area per le info dettagliate
          SliverToBoxAdapter(
            child: EventDetailInfo(event: event),
          ),
        ],
      ),
    );
  }
}
