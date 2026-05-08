import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/trip_model.dart';
import '../services/database_service.dart';
import 'bottom_nav.dart';

/// A screen that provides a form for users to create a new trip, including image upload and date selection.
class CreateTripScreen extends StatefulWidget {
  /// The unique ID of the currently logged-in user.
  final String userId;
  
  const CreateTripScreen({super.key, required this.userId});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  /// State variables to hold selected dates and form key.
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  final _formKey = GlobalKey<FormState>();

  /// Controllers for managing text input in the form.
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _tripDestinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _tripBudgetController = TextEditingController();

  /// Image selection and upload state variables.
  File? _image;
  final _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void dispose() {
    _tripNameController.dispose();
    _tripDestinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _tripBudgetController.dispose();
    super.dispose();
  }

  /// Opens the gallery to allow the user to pick an image for the trip.
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  /// Validates the form, uploads the image to ImgBB, and saves the trip to Firestore.
  void _saveTrip() async {
    // 1. Resolve User ID
    final String currentUserId = widget.userId.isNotEmpty
        ? widget.userId
        : (FirebaseAuth.instance.currentUser?.uid ?? '');

    if (currentUserId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: You must be logged in to create a trip."),
          ),
        );
      }
      return;
    }

    // 2. Validate the form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      String coverImageUrl = '';

      // 3. Upload image to ImgBB if selected
      if (_image != null) {
        try {
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.imgbb.com/1/upload?key=dd132aa992e339f842ad0eaa6de7130e',
            ),
          );
          request.files.add(
            await http.MultipartFile.fromPath('image', _image!.path),
          );

          final response = await request.send();
          if (response.statusCode == 200) {
            final responseData = await response.stream.bytesToString();
            final json = jsonDecode(responseData);
            coverImageUrl = json['data']['url'];
          } else {
            throw Exception('Failed to upload image to ImgBB');
          }
        } catch (e) {
          debugPrint('Error uploading image: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image upload failed: $e")),
            );
          }
        }
      }

      try {
        // 4. Create a Trip object
        final newTrip = Trip(
          id: '', // Firestore auto-generates this
          name: _tripNameController.text.trim(),
          destination: _tripDestinationController.text.trim(),
          startDate: _selectedStartDate!,
          endDate: _selectedEndDate!,
          budget: double.parse(_tripBudgetController.text.trim()),
          coverImageUrl: coverImageUrl,
        );

        // 5. Save to Firestore
        await DatabaseService(userId: currentUserId).addTrip(newTrip);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Trip created successfully!")),
          );

          // 6. Navigate back to Home
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
            (route) => false,
          );
        }
      } catch (e) {
        debugPrint('Error saving trip: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save trip: $e")),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  /// Displays a [DatePicker] to select the start or end date of the trip.
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_selectedStartDate ?? DateTime.now())
          : (_selectedEndDate ?? _selectedStartDate ?? DateTime.now()),
      firstDate: isStart
          ? DateTime.now()
          : (_selectedStartDate ?? DateTime.now()),
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

  /// Helper widget to build consistent text input fields with labels and icons.
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
                  
                  /// Form Container
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
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a trip name'
                              : null,
                        ),
                        _buildTextField(
                          label: "Destination",
                          hint: "City, Country, or Region",
                          textInputType: TextInputType.streetAddress,
                          controller: _tripDestinationController,
                          icon: const Icon(
                            Icons.location_pin,
                            color: Colors.grey,
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter a destination'
                              : null,
                        ),
                        _buildTextField(
                          label: "Start Date",
                          hint: "mm/dd/yyyy",
                          textInputType: TextInputType.datetime,
                          controller: _startDateController,
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a start date'
                              : null,
                        ),
                        _buildTextField(
                          label: "End Date",
                          hint: "mm/dd/yyyy",
                          textInputType: TextInputType.datetime,
                          controller: _endDateController,
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context, false),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select an end date'
                              : null,
                        ),
                        _buildTextField(
                          label: "Budget",
                          hint: "0.00",
                          textInputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: _tripBudgetController,
                          icon: const Icon(
                            Icons.attach_money,
                            color: Colors.grey,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter a budget';
                            if (double.tryParse(value) == null)
                              return 'Please enter a valid number';
                            return null;
                          },
                        ),

                        /// Image Picker UI
                        const Text(
                          "Trip Cover Image",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              image: _image != null
                                  ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Tap to select image",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a4dd5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
