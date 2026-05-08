import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trip_model.dart'; // Import your model

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId; // Pass the logged-in user's ID here

  DatabaseService({required this.userId});

  // 1. ADD A TRIP (Used by Team Member 2 on Create Trip Screen)
  Future<void> addTrip(Trip trip) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .add(trip.toFirestore());
  }

  // 2. GET ALL TRIPS (Used by Team Member 2 on Home Screen)
  Stream<List<Trip>> streamUserTrips() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Trip.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // You will also add methods here for: addActivity(), streamActivities(), addExpense(), etc.
}
