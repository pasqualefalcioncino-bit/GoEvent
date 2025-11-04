import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../utils/filter_controller.dart';

// Bottoni filtri per i vari eventi
class FilterSheet extends StatefulWidget {
  final EventProvider provider;

  const FilterSheet({super.key, required this.provider});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final FilterController controller;
  String? selectedCity;
  DateTime? selectedDate;
  bool showFavorites = false;

  @override
  void initState() {
    super.initState();
    controller = FilterController(widget.provider);
    selectedCity = widget.provider.cityFilter;
    selectedDate = widget.provider.dateFilter;
    showFavorites = widget.provider.showFavoritesOnly;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Otteniamo tutte le città presenti negli eventi, ordinate alfabeticamente
    final cities = widget.provider.allEvents
        .map((e) => e.city)
        .where((c) => c != null && c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHandle(),
                  _buildTitle(),
                  const SizedBox(height: 20),
                  _buildCityFilter(cities, theme),
                  const SizedBox(height: 24),
                  _buildDateFilter(dateFormat),
                  const SizedBox(height: 24),
                  _buildFavoritesSwitch(theme),
                  const Divider(height: 32),
                  _buildActions(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Barra centrale
  Widget _buildHandle() => Center(
    child: Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  // Titolo centrale
  Widget _buildTitle() => const Center(
    child: Text(
      'Filtra eventi',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // Filtra per città tramite ChoiceChip
  Widget _buildCityFilter(List<String> cities, ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Città', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: cities.map((city) {
          final selected = city == selectedCity;
          return ChoiceChip(
            label: Text(city),
            selected: selected,
            onSelected: (_) =>
                setState(() => selectedCity = selected ? null : city),
            selectedColor: Colors.purple.shade200,
            labelStyle: TextStyle(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          );
        }).toList(),
      ),
    ],
  );

  // Per selezionare la data
  Widget _buildDateFilter(DateFormat dateFormat) => Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(
            selectedDate != null
                ? dateFormat.format(selectedDate!)
                : 'Seleziona data',
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
        ),
      ),
      if (selectedDate != null)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => setState(() => selectedDate = null),
        ),
    ],
  );

  // Switch per mostrare solo eventi preferiti
  Widget _buildFavoritesSwitch(ThemeData theme) => Row(
    children: [
      Switch(
        value: showFavorites,
        onChanged: (value) => setState(() => showFavorites = value),
      ),
      const SizedBox(width: 8),
      const Text('Mostra solo preferiti', style: TextStyle(fontSize: 16)),
    ],
  );

  // Bottoni per cancellare i filtri o applicarli
  Widget _buildActions(ThemeData theme) => Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          icon: const Icon(Icons.delete_outline),
          label: const Text('Cancella tutto'),
          onPressed: _clearFilters,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Applica'),
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ],
  );

  // Applica i filtri
  void _applyFilters() {
    controller.applyFilters(
      city: selectedCity,
      date: selectedDate,
      showFavorites: showFavorites,
    );
    Navigator.pop(context);
  }

  // Cancella tutti i filtri
  void _clearFilters() {
    controller.clearFilters();
    setState(() {
      selectedCity = null;
      selectedDate = null;
      showFavorites = false;
    });
    Navigator.pop(context);
  }
}
