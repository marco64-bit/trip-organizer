import 'package:flutter/material.dart';
import 'package:trip_organizer/views/app_bar_component.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextInputType textInputType,
    required TextEditingController controller,
    Icon? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
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
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Create Trip"),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFf7f9fc),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan Your Next Adventure",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Fill in the details to start organizing your new trip.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
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
                      ),
                      _buildTextField(
                        label: "Destination",
                        hint: "City, Country, or Region",
                        textInputType: TextInputType.streetAddress,
                        controller: _tripDestinationController,
                        icon: Icon(Icons.location_pin, color: Colors.grey),
                      ),
                      _buildTextField(
                        label: "Start Date",
                        hint: "mm/dd/yyyy",
                        textInputType: TextInputType.datetime,
                        controller: _startDateController,
                        icon: Icon(Icons.calendar_today, color: Colors.grey),
                      ),
                      _buildTextField(
                        label: "End Date",
                        hint: "mm/dd/yyyy",
                        textInputType: TextInputType.datetime,
                        controller: _endDateController,
                        icon: Icon(Icons.calendar_month, color: Colors.grey),
                      ),
                      _buildTextField(
                        label: "Budget",
                        hint: "0.00",
                        textInputType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _tripBudgetController,
                        icon: Icon(Icons.attach_money, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement trip creation logic
                      Navigator.pushReplacementNamed(context, '/bottom_nav');
                    },
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
    );
  }
}
