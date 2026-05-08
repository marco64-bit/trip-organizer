import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/trip_model.dart';
import '../services/database_service.dart';

class CreateTripScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user's ID
  const CreateTripScreen({super.key, required this.userId});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}
class _CreateTripScreenState extends State<CreateTripScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _tripDestinationController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _tripBudgetController = TextEditingController();

  @override
  void dispose() {
    _tripNameController.dispose();
    _tripDestinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _tripBudgetController.dispose();
    super.dispose();
  }

  void _saveTrip() async {
    // 1. Validate the form
    if (_formKey.currentState!.validate()) {
      // 2. Create a Trip object from the input
      final newTrip = Trip(
        id: '',
        // Firestore will auto-generate the ID when saving
        name: _tripNameController.text.trim(),
        destination: _tripDestinationController.text.trim(),
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
        budget: double.parse(_tripBudgetController.text.trim()),
      );

      // 3. Send it to Firestore using Member 5's DatabaseService
      await DatabaseService(userId: widget.userId).addTrip(newTrip);

      // 4. Go back to the Home Screen
      if (mounted) Navigator.pop(context);
    }
  }
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_selectedStartDate ?? DateTime.now()) : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now()),
      firstDate: isStart ? DateTime.now() : (_selectedStartDate ?? DateTime.now()),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = picked;
          _startDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        } else {
          _selectedEndDate = picked;
          _endDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        }
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextInputType textInputType,
    required TextEditingController controller,
    Icon? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: icon,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1a4dd5), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Trip"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFf7f9fc),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Plan Your Next Adventure",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Fill in the details to start organizing your new trip.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(width: 4, color: Color(0xFF1a4dd5)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: "Trip Name",
                          hint: "e.g., Summer in Tokyo",
                          textInputType: TextInputType.text,
                          controller: _tripNameController,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter a trip name' : null,
                        ),
                        _buildTextField(
                          label: "Destination",
                          hint: "City, Country, or Region",
                          textInputType: TextInputType.streetAddress,
                          controller: _tripDestinationController,
                          icon: const Icon(Icons.location_pin, color: Colors.grey),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter a destination' : null,
                        ),
                        _buildTextField(
                          label: "Start Date",
                          hint: "mm/dd/yyyy",
                          textInputType: TextInputType.datetime,
                          controller: _startDateController,
                          icon: const Icon(Icons.calendar_today, color: Colors.grey),
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please select a start date' : null,
                        ),
                        _buildTextField(
                          label: "End Date",
                          hint: "mm/dd/yyyy",
                          textInputType: TextInputType.datetime,
                          controller: _endDateController,
                          icon: const Icon(Icons.calendar_month, color: Colors.grey),
                          readOnly: true,
                          onTap: () => _selectDate(context, false),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please select an end date' : null,
                        ),
                        _buildTextField(
                          label: "Budget",
                          hint: "0.00",
                          textInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: _tripBudgetController,
                          icon: const Icon(Icons.attach_money, color: Colors.grey),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter a budget';
                            if (double.tryParse(value) == null) return 'Please enter a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a4dd5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Create Trip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
