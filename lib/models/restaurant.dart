import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String location;
  final String address;
  final String? description;
  final String? imageUrl;
  final double rating;
  final int ratingCount;
  final bool isOpen;
  final PickUpSchedule pickUpSchedule;
  final String? phoneNumber;
  final String? email;
  final List<String> cuisineTypes;

  const Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    this.description,
    this.imageUrl,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isOpen = true,
    required this.pickUpSchedule,
    this.phoneNumber,
    this.email,
    this.cuisineTypes = const [],
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? 'Unknown Restaurant',
      location: map['location'] ?? '',
      address: map['address'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'] ?? map['image'],
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0.0,
      ratingCount: map['ratingCount'] ?? map['rating_count'] ?? 0,
      isOpen: map['isOpen'] ?? map['is_open'] ?? true,
      pickUpSchedule: PickUpSchedule.fromMap(map['pickUpSchedule'] ?? map['pickup_schedule'] ?? {}),
      phoneNumber: map['phoneNumber'] ?? map['phone_number'],
      email: map['email'],
      cuisineTypes: _parseCuisineTypes(map['cuisineTypes'] ?? map['cuisine_types']),
    );
  }

  static List<String> _parseCuisineTypes(dynamic cuisineTypes) {
    if (cuisineTypes == null) return [];
    if (cuisineTypes is List) {
      return cuisineTypes.map((item) => item.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'location': location,
    'address': address,
    'description': description,
    'imageUrl': imageUrl,
    'rating': rating,
    'ratingCount': ratingCount,
    'isOpen': isOpen,
    'pickUpSchedule': pickUpSchedule.toMap(),
    'phoneNumber': phoneNumber,
    'email': email,
    'cuisineTypes': cuisineTypes,
  };

  Restaurant copyWith({
    String? id,
    String? name,
    String? location,
    String? address,
    String? description,
    String? imageUrl,
    double? rating,
    int? ratingCount,
    bool? isOpen,
    PickUpSchedule? pickUpSchedule,
    String? phoneNumber,
    String? email,
    List<String>? cuisineTypes,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isOpen: isOpen ?? this.isOpen,
      pickUpSchedule: pickUpSchedule ?? this.pickUpSchedule,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    address,
    description,
    imageUrl,
    rating,
    ratingCount,
    isOpen,
    pickUpSchedule,
    phoneNumber,
    email,
    cuisineTypes,
  ];
}

class PickUpSchedule extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> availableDays; // 1 = Monday, 7 = Sunday
  final bool isAlwaysOpen;

  const PickUpSchedule({
    required this.startTime,
    required this.endTime,
    this.availableDays = const [1, 2, 3, 4, 5, 6, 7], // All days by default
    this.isAlwaysOpen = false,
  });

  factory PickUpSchedule.fromMap(Map<String, dynamic> map) {
    return PickUpSchedule(
      startTime: _parseTimeOfDay(map['startTime'] ?? map['start_time'] ?? '09:00'),
      endTime: _parseTimeOfDay(map['endTime'] ?? map['end_time'] ?? '21:00'),
      availableDays: _parseAvailableDays(map['availableDays'] ?? map['available_days']),
      isAlwaysOpen: map['isAlwaysOpen'] ?? map['is_always_open'] ?? false,
    );
  }

  static TimeOfDay _parseTimeOfDay(dynamic time) {
    if (time is String) {
      try {
        final parts = time.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return TimeOfDay(hour: hour, minute: minute);
        }
      } catch (e) {
        // If parsing fails, return default time
      }
    }
    return const TimeOfDay(hour: 9, minute: 0); // Default 9:00 AM
  }

  static List<int> _parseAvailableDays(dynamic days) {
    if (days == null) return [1, 2, 3, 4, 5, 6, 7]; // All days
    if (days is List) {
      return days.map((day) => day is int ? day : int.tryParse(day.toString()) ?? 1).toList();
    }
    return [1, 2, 3, 4, 5, 6, 7];
  }

  Map<String, dynamic> toMap() => {
    'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
    'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
    'availableDays': availableDays,
    'isAlwaysOpen': isAlwaysOpen,
  };

  String get formattedStartTime => '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  String get formattedEndTime => '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  
  String get scheduleText {
    if (isAlwaysOpen) return '24/7';
    return '$formattedStartTime - $formattedEndTime';
  }

  List<String> get availableDaysNames {
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return availableDays.map((dayNum) => dayNames[dayNum - 1]).toList();
  }

  bool get isOpenAllWeek => availableDays.length == 7;

  bool isOpenOnDay(int dayOfWeek) => availableDays.contains(dayOfWeek);

  bool isOpenNow() {
    if (isAlwaysOpen) return true;
    
    final now = DateTime.now();
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    final currentTime = TimeOfDay.fromDateTime(now);
    
    if (!isOpenOnDay(currentDay)) return false;
    
    // Simple time comparison (doesn't handle overnight schedules)
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    
    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  PickUpSchedule copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<int>? availableDays,
    bool? isAlwaysOpen,
  }) {
    return PickUpSchedule(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      availableDays: availableDays ?? this.availableDays,
      isAlwaysOpen: isAlwaysOpen ?? this.isAlwaysOpen,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, availableDays, isAlwaysOpen];
}

// Extension to add TimeOfDay comparison
extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
  
  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }
}
