import 'package:flutter/material.dart';

/// A comprehensive budget screen that displays expenses and budget status.
class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  /// Mock data for demonstration. In a real app, this would come from Firestore.
  final double totalBudget = 5000.0;
  final double totalSpent = 1250.50;

  Widget _buildSummaryCard() {
    double progress = (totalSpent / totalBudget).clamp(0.0, 1.0);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1d4ed8), Color(0xFF1a4dd5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1d4ed8).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Budget Overview",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${totalSpent.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "of \$${totalBudget.toInt()}",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${(progress * 100).toInt()}% of budget used",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, double amount, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Last spent 2 days ago",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "-\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fc),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 30),
              const Text(
                "Expenses by Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003d9b),
                ),
              ),
              const SizedBox(height: 15),
              _buildCategoryItem("Food & Drinks", 450.00, Icons.restaurant, Colors.orange),
              _buildCategoryItem("Transport", 320.50, Icons.directions_bus, Colors.blue),
              _buildCategoryItem("Accommodation", 280.00, Icons.hotel, Colors.purple),
              _buildCategoryItem("Activities", 150.00, Icons.local_activity, Colors.green),
              _buildCategoryItem("Others", 50.00, Icons.more_horiz, Colors.grey),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Expense"),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1d4ed8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
