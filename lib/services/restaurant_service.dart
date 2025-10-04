import 'dart:async';
import 'package:flutter/material.dart';
import '../models/restaurant.dart';

/// Simulated data service for restaurants. Replace with real API / DB layer later.
class RestaurantService {
  Future<List<Restaurant>> fetchRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      Restaurant(
        id: '1',
        name: 'Italian Bistro',
        location: 'Downtown',
        address: '123 Main Street, Downtown City',
        description:
            'Authentic Italian cuisine with a modern twist. Fresh pasta made daily.',
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
        rating: 4.5,
        ratingCount: 234,
        isOpen: true,
        pickUpSchedule: const PickUpSchedule(
          startTime: TimeOfDay(hour: 11, minute: 0),
          endTime: TimeOfDay(hour: 22, minute: 0),
          availableDays: [1, 2, 3, 4, 5, 6], // Mon-Sat
        ),
        phoneNumber: '+1 (555) 123-4567',
        email: 'info@italianbistro.com',
        cuisineTypes: const ['Italian', 'Mediterranean', 'Pasta'],
      ),
      Restaurant(
        id: '2',
        name: 'Caribbean Delight',
        location: 'Uptown',
        address: '456 Oak Avenue, Uptown District',
        description:
            'Traditional Caribbean flavors with fresh tropical ingredients.',
        imageUrl:
            'https://images.unsplash.com/photo-1551218808-94e220e084d2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
        rating: 4.2,
        ratingCount: 156,
        isOpen: true,
        pickUpSchedule: const PickUpSchedule(
          startTime: TimeOfDay(hour: 10, minute: 30),
          endTime: TimeOfDay(hour: 21, minute: 30),
          availableDays: [1, 2, 3, 4, 5, 6, 7], // All week
        ),
        phoneNumber: '+1 (555) 987-6543',
        email: 'hello@caribbeandelight.com',
        cuisineTypes: const ['Caribbean', 'Latin American', 'Seafood'],
      ),
      Restaurant(
        id: '3',
        name: 'Zen Garden Asian',
        location: 'Midtown',
        address: '789 Bamboo Lane, Midtown Plaza',
        description:
            'Pan-Asian cuisine featuring dishes from Japan, Thailand, and Vietnam.',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        rating: 4.7,
        ratingCount: 312,
        isOpen: false, // Currently closed
        pickUpSchedule: const PickUpSchedule(
          startTime: TimeOfDay(hour: 12, minute: 0),
          endTime: TimeOfDay(hour: 23, minute: 0),
          availableDays: [2, 3, 4, 5, 6, 7], // Tue-Sun (closed Mondays)
        ),
        phoneNumber: '+1 (555) 456-7890',
        email: 'orders@zengardenasian.com',
        cuisineTypes: const ['Asian', 'Japanese', 'Thai', 'Vietnamese'],
      ),
      Restaurant(
        id: '4',
        name: 'Burger Palace',
        location: 'Mall District',
        address: '321 Food Court, Shopping Mall',
        description:
            'Gourmet burgers and loaded fries. Always fresh, never frozen.',
        imageUrl:
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2072&q=80',
        rating: 4.0,
        ratingCount: 89,
        isOpen: true,
        pickUpSchedule: const PickUpSchedule(
          startTime: TimeOfDay(hour: 10, minute: 0),
          endTime: TimeOfDay(hour: 24, minute: 0), // Until midnight
          availableDays: [1, 2, 3, 4, 5, 6, 7], // All week
        ),
        phoneNumber: '+1 (555) 111-2222',
        email: 'info@burgerpalace.com',
        cuisineTypes: const ['American', 'Fast Food', 'Burgers'],
      ),
      Restaurant(
        id: '5',
        name: 'Café Luna',
        location: 'Arts Quarter',
        address: '654 Gallery Street, Arts Quarter',
        description:
            'Cozy café serving artisanal coffee, pastries, and light meals.',
        imageUrl:
            'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2047&q=80',
        rating: 4.3,
        ratingCount: 67,
        isOpen: true,
        pickUpSchedule: const PickUpSchedule(
          startTime: TimeOfDay(hour: 7, minute: 0),
          endTime: TimeOfDay(hour: 18, minute: 0),
          availableDays: [1, 2, 3, 4, 5], // Weekdays only
        ),
        phoneNumber: '+1 (555) 333-4444',
        email: 'hello@cafeluna.com',
        cuisineTypes: const ['Café', 'Coffee', 'Pastries', 'Light Meals'],
      ),
    ];
  }

  Future<Restaurant> fetchRestaurantById(String id) async {
    final restaurants = await fetchRestaurants();
    return restaurants.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Restaurant not found'),
    );
  }

  Future<List<Restaurant>> fetchRestaurantsByLocation(String location) async {
    final restaurants = await fetchRestaurants();
    return restaurants
        .where((r) => r.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
  }

  Future<List<Restaurant>> fetchRestaurantsByCuisine(String cuisine) async {
    final restaurants = await fetchRestaurants();
    return restaurants
        .where(
          (r) => r.cuisineTypes.any(
            (type) => type.toLowerCase().contains(cuisine.toLowerCase()),
          ),
        )
        .toList();
  }

  Future<List<Restaurant>> fetchOpenRestaurants() async {
    final restaurants = await fetchRestaurants();
    return restaurants
        .where((r) => r.isOpen && r.pickUpSchedule.isOpenNow())
        .toList();
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final restaurants = await fetchRestaurants();
    final lowerQuery = query.toLowerCase();

    return restaurants
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
}
