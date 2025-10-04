import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';

class RestaurantController extends ChangeNotifier {
  final RestaurantService _service;

  RestaurantController(this._service);

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedLocation = '';
  String _selectedCuisine = '';
  bool _showOnlyOpen = false;

  // Getters
  List<Restaurant> get restaurants =>
      _filteredRestaurants.isEmpty ? _restaurants : _filteredRestaurants;
  List<Restaurant> get allRestaurants => _restaurants;
  bool get isLoading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedLocation => _selectedLocation;
  String get selectedCuisine => _selectedCuisine;
  bool get showOnlyOpen => _showOnlyOpen;

  // Get unique locations from all restaurants
  List<String> get availableLocations {
    return _restaurants.map((r) => r.location).toSet().toList()..sort();
  }

  // Get unique cuisine types from all restaurants
  List<String> get availableCuisines {
    final cuisines = <String>{};
    for (final restaurant in _restaurants) {
      cuisines.addAll(restaurant.cuisineTypes);
    }
    return cuisines.toList()..sort();
  }

  List<Restaurant> get openRestaurants {
    return _restaurants
        .where((r) => r.isOpen && r.pickUpSchedule.isOpenNow())
        .toList();
  }

  List<Restaurant> get topRatedRestaurants {
    return _restaurants.where((r) => r.rating >= 4.0).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  Future<void> loadRestaurants() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _service.fetchRestaurants();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Restaurant?> getRestaurantById(String id) async {
    try {
      // First check if restaurant is already loaded
      final restaurant = _restaurants.where((r) => r.id == id).firstOrNull;
      if (restaurant != null) {
        return restaurant;
      }

      // If not found, fetch from service
      return await _service.fetchRestaurantById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void searchRestaurants(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByLocation(String location) {
    _selectedLocation = location;
    _applyFilters();
    notifyListeners();
  }

  void filterByCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    _applyFilters();
    notifyListeners();
  }

  void toggleShowOnlyOpen() {
    _showOnlyOpen = !_showOnlyOpen;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedLocation = '';
    _selectedCuisine = '';
    _showOnlyOpen = false;
    _filteredRestaurants = [];
    notifyListeners();
  }

  void _applyFilters() {
    List<Restaurant> filtered = List.from(_restaurants);

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (r) =>
                r.name.toLowerCase().contains(lowerQuery) ||
                r.description?.toLowerCase().contains(lowerQuery) == true ||
                r.location.toLowerCase().contains(lowerQuery) ||
                r.cuisineTypes.any(
                  (type) => type.toLowerCase().contains(lowerQuery),
                ),
          )
          .toList();
    }

    // Apply location filter
    if (_selectedLocation.isNotEmpty) {
      filtered = filtered
          .where((r) => r.location == _selectedLocation)
          .toList();
    }

    // Apply cuisine filter
    if (_selectedCuisine.isNotEmpty) {
      filtered = filtered
          .where((r) => r.cuisineTypes.contains(_selectedCuisine))
          .toList();
    }

    // Apply open-only filter
    if (_showOnlyOpen) {
      filtered = filtered
          .where((r) => r.isOpen && r.pickUpSchedule.isOpenNow())
          .toList();
    }

    _filteredRestaurants = filtered;
  }

  // Helper method to refresh restaurant data
  Future<void> refresh() async {
    await loadRestaurants();
  }

  // Get restaurants sorted by different criteria
  List<Restaurant> getRestaurantsSortedBy(RestaurantSortOption sortOption) {
    final restaurantsList = List<Restaurant>.from(restaurants);

    switch (sortOption) {
      case RestaurantSortOption.name:
        restaurantsList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case RestaurantSortOption.rating:
        restaurantsList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RestaurantSortOption.location:
        restaurantsList.sort((a, b) => a.location.compareTo(b.location));
        break;
      case RestaurantSortOption.openStatus:
        restaurantsList.sort((a, b) {
          final aOpen = a.isOpen && a.pickUpSchedule.isOpenNow();
          final bOpen = b.isOpen && b.pickUpSchedule.isOpenNow();
          if (aOpen && !bOpen) return -1;
          if (!aOpen && bOpen) return 1;
          return 0;
        });
        break;
    }

    return restaurantsList;
  }
}

enum RestaurantSortOption { name, rating, location, openStatus }

// Extension to add firstOrNull method if not available
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
