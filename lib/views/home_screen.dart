import 'package:flutter/material.dart';
import 'package:trip_organizer/views/app_bar_component.dart';
import 'app_drawer.dart';
import 'bottom_nav.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Reusable Trip Card Component
  Widget getTripCard({
    required String title,
    required String location,
    required String dateRange,
    required String imagePath,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.transparent,
      ),
      child: Card(
        margin: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
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
                        "Completed",
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.map_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(location, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Colors.grey),
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
    return SingleChildScrollView(


        child: Container(
          color: Color(0xFFf7f9fc),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "YOUR JOURNEYS",
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF003d9b),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Explore the World",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/suggested_trip.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 220,
                    width: 330,
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Color(0xff003d9b),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "AUG 12 - AUG 20",
                                  style: TextStyle(color: Color(0xff434654)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Color(0xFF1c4cd5),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Greece",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1c4cd5),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "Summer in Santorini",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Past Memories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                getTripCard(
                  title: "Autumn in Kyoto",
                  location: "Japan",
                  dateRange: "Oct 15 - Oct 25, 2023",
                  imagePath: "lib/assets/past_trip1.jpg",
                ),
                const SizedBox(height: 16),
                getTripCard(
                  title: "Spring in Paris",
                  location: "France",
                  dateRange: "May 10 - May 20, 2023",
                  imagePath: "lib/assets/past_trip2.jpg",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),


    );
  }
}
