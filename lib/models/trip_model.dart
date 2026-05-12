import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String coverImageUrl; // Added for the Home Screen cards

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.coverImageUrl = '',
  });

  factory Trip.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Trip(
      id: documentId,
      name: data['name'] ?? '',
      destination: data['destination'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      budget: (data['budget'] ?? 0.0).toDouble(),
      coverImageUrl: data['coverImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'destination': destination,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'budget': budget,
      'coverImageUrl': coverImageUrl,
    };
  }


}