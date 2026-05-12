import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/activity_model.dart';
import '../models/expense_model.dart';
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

  // 3. ADD AN EXPENSE
  Future<void> addExpense(String tripId, Expense expense) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .add(expense.toFirestore());
  }

  // 4. GET ALL EXPENSES FOR A TRIP
  Stream<List<Expense>> streamExpenses(String tripId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // 5. ADD AN ACTIVITY
  Future<void> addActivity(String tripId, Activity activity) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .doc(tripId)
        .collection('activities')
        .add(activity.toFirestore());
  }

  // 6. GET ALL ACTIVITIES FOR A TRIP
  Stream<List<Activity>> streamActivities(String tripId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .doc(tripId)
        .collection('activities')
        .orderBy('time', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Activity.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // You will also add methods here for: addActivity(), streamActivities(), addExpense(), etc.
}
