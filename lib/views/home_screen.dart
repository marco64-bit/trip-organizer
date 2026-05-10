import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_organizer/models/trip_model.dart';
import 'package:trip_organizer/services/database_service.dart';

/// The primary landing screen that displays a list of the user's trips fetched from Firestore.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Builds a reusable card widget to display trip details.
  ///
  /// [title] is the name of the trip.
  /// [location] is the trip destination.
  /// [dateRange] is a formatted string of the trip's start and end dates.
  /// [imageUrl] is the path to an asset or a network URL for the cover image.
  Widget getTripCard({
    required String title,
    required String location,
    required String dateRange,
    required String imageUrl,
  }) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Navigate to trip details screen
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.transparent,
      ),
      child: Card(
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            /// Cover image container with a "Trip" label overlay.
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageUrl.startsWith('http')
                      ? NetworkImage(imageUrl)
                      : AssetImage(imageUrl) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFddebf6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: const Text(
                        "Trip",
                        style: TextStyle(
                          color: Color(0xFF1d4ed8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Trip information section (Title, Location, Date).
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(location, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateRange,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
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
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFf7f9fc),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "YOUR JOURNEYS",
                style: TextStyle(
                  letterSpacing: 1,
                  color: Color(0xFF003d9b),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Explore the World",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(height: 20),

              /// StreamBuilder to listen for real-time updates from Firestore.
              if (user != null)
                StreamBuilder<List<Trip>>(
                  stream: DatabaseService(userId: user.uid).streamUserTrips(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final trips = snapshot.data ?? [];

                    /// Placeholder when the user has no trips.
                    if (trips.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No trips found. Start planning!"),
                        ),
                      );
                    }

                    /// List of trip cards generated from the fetched data.
                    return Column(
                      children: trips.map((trip) {
                        String dateRange =
                            "${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}";
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: getTripCard(
                            title: trip.name,
                            location: trip.destination,
                            dateRange: dateRange,
                            imageUrl: trip.coverImageUrl.isNotEmpty
                                ? trip.coverImageUrl
                                : 'lib/assets/suggested_trip.jpg',
                          ),
                        );
                      }).toList(),
                    );
                  },
                )
              else
                const Center(child: Text("Please log in to see your trips.")),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
