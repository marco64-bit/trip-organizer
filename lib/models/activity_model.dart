import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityCategory {
  flight,
  hotel,
  activity,
  restaurant,
  transport,
  entertainment
}

class Activity {
  final String id;
  final String title;
  final DateTime time;
  final String location;
  final ActivityCategory category; // Updated to Enum
  final String details;

  Activity({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    this.details = '',
  });

  factory Activity.fromFirestore(Map<String, dynamic> data, String documentId) {
    // 1. Get the string from Firestore (default to 'activity' if missing)
    final categoryString = data['category'] ?? 'activity';

    // 2. Safely convert the String back to the Enum
    final categoryEnum = ActivityCategory.values.firstWhere(
          (e) => e.name == categoryString,
      orElse: () => ActivityCategory.activity, // Fallback if string doesn't match
    );

    return Activity(
      id: documentId,
      title: data['title'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      category: categoryEnum,
      details: data['details'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': Timestamp.fromDate(time),
      'location': location,
      // Convert the Enum to a simple String using .name before saving
      'category': category.name,
      'details': details,
    };
  }
}