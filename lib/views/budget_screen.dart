import 'package:flutter/material.dart';
import 'package:trip_organizer/models/expense_model.dart';
import 'package:trip_organizer/models/trip_model.dart';
import 'package:trip_organizer/services/database_service.dart';

/// A comprehensive budget screen that displays expenses and budget status for a specific trip.
class BudgetScreen extends StatefulWidget {
  final String userId;
  const BudgetScreen({super.key, required this.userId});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Trip? _selectedTrip;

  /// Helper to get icon for a category
  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_bus;
      case ExpenseCategory.flights:
        return Icons.flight;
      case ExpenseCategory.accommodation:
        return Icons.hotel;
      case ExpenseCategory.activities:
        return Icons.local_activity;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  /// Helper to get color for a category
  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.flights:
        return Colors.cyan;
      case ExpenseCategory.accommodation:
        return Colors.purple;
      case ExpenseCategory.activities:
        return Colors.green;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }

  void _showAddExpenseDialog() {
    if (_selectedTrip == null) return;

    final titleController = TextEditingController();
    final amountController = TextEditingController();
    ExpenseCategory selectedCategory = ExpenseCategory.food;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add New Expense",
            style: TextStyle(
              color: Color(0xFF1d4ed8),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<ExpenseCategory>(
                initialValue: selectedCategory,
                items: ExpenseCategory.values
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedCategory = val!),
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null) {
                    final newExpense = Expense(
                      id: '',
                      title: titleController.text,
                      amount: amount,
                      date: DateTime.now(),
                      category: selectedCategory,
                    );

                    await DatabaseService(userId: widget.userId)
                        .addExpense(_selectedTrip!.id, newExpense);
                    
                    if (context.mounted) Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1d4ed8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add Expense"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double totalSpent, double totalBudget) {
    double progress = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;

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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
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

  Widget _buildCategoryItem(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Expense",
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
      body: StreamBuilder<List<Trip>>(
        stream: DatabaseService(userId: widget.userId).streamUserTrips(),
        builder: (context, tripSnapshot) {
          if (tripSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = tripSnapshot.data ?? [];

          if (trips.isEmpty) {
            return const Center(
              child: Text("No trips found. Create a trip first!"),
            );
          }

          // Initialize _selectedTrip if not set or if current selection is not in list
          if (_selectedTrip == null || !trips.any((t) => t.id == _selectedTrip!.id)) {
            _selectedTrip = trips.first;
          } else {
            // Update _selectedTrip with latest data from stream
            _selectedTrip = trips.firstWhere((t) => t.id == _selectedTrip!.id);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Trip",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003d9b),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Trip>(
                    initialValue: _selectedTrip,
                    items: trips
                        .map(
                          (trip) => DropdownMenuItem(
                            value: trip,
                            child: Text(trip.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedTrip = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<List<Expense>>(
                    stream: DatabaseService(userId: widget.userId)
                        .streamExpenses(_selectedTrip!.id),
                    builder: (context, expenseSnapshot) {
                      final expenses = expenseSnapshot.data ?? [];
                      final double totalSpent = expenses.fold(
                        0.0,
                        (sum, item) => sum + item.amount,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryCard(totalSpent, _selectedTrip!.budget),
                          const SizedBox(height: 30),
                          const Text(
                            "Expenses",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003d9b),
                            ),
                          ),
                          const SizedBox(height: 15),
                          if (expenses.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No expenses recorded for this trip."),
                              ),
                            )
                          else
                            ...expenses.map(
                              (expense) => _buildCategoryItem(
                                expense.title,
                                expense.amount,
                                _getCategoryIcon(expense.category),
                                _getCategoryColor(expense.category),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton.icon(
                      onPressed: _showAddExpenseDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Expense"),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1d4ed8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
