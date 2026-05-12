import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_organizer/models/trip_model.dart';
import 'package:trip_organizer/services/database_service.dart';
import '../models/activity_model.dart';

/// A screen to display and manage the itinerary of a specific trip.
class ItineraryScreen extends StatefulWidget {
  final String userId;
  const ItineraryScreen({super.key, required this.userId});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  Trip? _selectedTrip;
  DateTime? _selectedDay;

  /// Helper to get the list of days for the selected trip.
  List<DateTime> _getTripDays(Trip trip) {
    final days = <DateTime>[];
    for (int i = 0; i <= trip.endDate.difference(trip.startDate).inDays; i++) {
      days.add(trip.startDate.add(Duration(days: i)));
    }
    return days;
  }

  /// Displays a dialog to add a new activity.
  void _showAddActivityDialog() {
    if (_selectedTrip == null || _selectedDay == null) return;

    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final detailsController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    ActivityCategory selectedCategory = ActivityCategory.activity;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add New Activity",
            style: TextStyle(
              color: Color(0xFF1d4ed8),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  title: Text("Time: ${selectedTime.format(context)}"),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setDialogState(() => selectedTime = picked);
                    }
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<ActivityCategory>(
                  initialValue: selectedCategory,
                  items: ActivityCategory.values
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: "Details",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final activityTime = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  final newActivity = Activity(
                    id: '',
                    title: titleController.text,
                    time: activityTime,
                    location: locationController.text,
                    category: selectedCategory,
                    details: detailsController.text,
                  );

                  await DatabaseService(userId: widget.userId)
                      .addActivity(_selectedTrip!.id, newActivity);

                  if (context.mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1d4ed8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Add Activity"),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for an individual activity in the itinerary.
  Widget _buildActivityCard(Activity activity) {
    IconData icon;
    switch (activity.category) {
      case ActivityCategory.flight:
        icon = Icons.flight_takeoff;
        break;
      case ActivityCategory.hotel:
        icon = Icons.hotel;
        break;
      case ActivityCategory.restaurant:
        icon = Icons.restaurant;
        break;
      case ActivityCategory.transport:
        icon = Icons.directions_bus;
        break;
      case ActivityCategory.entertainment:
        icon = Icons.theater_comedy;
        break;
      default:
        icon = Icons.event;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFddebf6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1d4ed8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('hh:mm a').format(activity.time),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  if (activity.location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          activity.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
            return const Center(child: Text("No trips found. Create a trip first!"));
          }

          if (_selectedTrip == null || !trips.any((t) => t.id == _selectedTrip!.id)) {
            _selectedTrip = trips.first;
            _selectedDay = _selectedTrip!.startDate;
          } else {
            _selectedTrip = trips.firstWhere((t) => t.id == _selectedTrip!.id);
          }

          final tripDays = _getTripDays(_selectedTrip!);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "UPCOMING PLANS",
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF003d9b),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Trip>(
                  initialValue: _selectedTrip,
                  items: trips
                      .map(
                        (trip) => DropdownMenuItem(
                          value: trip,
                          child: Text(trip.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedTrip = val;
                      _selectedDay = _selectedTrip!.startDate;
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tripDays.length,
                    itemBuilder: (context, index) {
                      final day = tripDays[index];
                      final isSelected = _selectedDay != null &&
                          day.year == _selectedDay!.year &&
                          day.month == _selectedDay!.month &&
                          day.day == _selectedDay!.day;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1d4ed8) : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(day).toUpperCase(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white70 : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<Activity>>(
                    stream: DatabaseService(userId: widget.userId).streamActivities(_selectedTrip!.id),
                    builder: (context, activitySnapshot) {
                      final activities = activitySnapshot.data ?? [];
                      final filteredActivities = activities.where((activity) {
                        return activity.time.year == _selectedDay!.year &&
                            activity.time.month == _selectedDay!.month &&
                            activity.time.day == _selectedDay!.day;
                      }).toList();

                      if (filteredActivities.isEmpty) {
                        return const Center(child: Text("No activities for this day."));
                      }

                      return ListView.builder(
                        itemCount: filteredActivities.length,
                        itemBuilder: (context, index) {
                          return _buildActivityCard(filteredActivities[index]);
                        },
                      );
                    },
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: _showAddActivityDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Activity"),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1d4ed8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
