import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpenseCategory {
  food,
  transport,
  flights,
  accommodation,
  activities,
  other
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category; // Updated to Enum

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Expense.fromFirestore(Map<String, dynamic> data, String documentId) {
    // 1. Get the string from Firestore
    final categoryString = data['category'] ?? 'other';

    // 2. Safely convert the String back to the Enum
    final categoryEnum = ExpenseCategory.values.firstWhere(
          (e) => e.name == categoryString,
      orElse: () => ExpenseCategory.other, // Fallback
    );

    return Expense(
      id: documentId,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: categoryEnum,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      // Convert the Enum to a String for Firebase
      'category': category.name,
    };
  }
}