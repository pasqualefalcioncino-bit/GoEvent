import '../providers/event_provider.dart';

// Gestisce i filtri sugli eventi
class FilterController {
  final EventProvider provider;

  FilterController(this.provider);

  // Applica i filtri al provider
  void applyFilters({
    String? city,
    DateTime? date,
    bool showFavorites = false,
  }) {
    provider.setCityFilter(city);
    provider.setDateFilter(date);
    provider.toggleShowFavorites(showFavorites);
  }

  // Resetta tutti i filtri
  void clearFilters() {
    provider.clearFilters();
  }
}
