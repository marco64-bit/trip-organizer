import 'package:flutter/material.dart';
import 'package:trip_organizer/views/bottom_nav.dart';
import 'package:trip_organizer/views/create_trip_screen.dart';
import 'package:trip_organizer/views/profile_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: BottomNav(),
      title: "Trip Organizer",
      routes: {
        '/bottom_nav': (context) => const BottomNav(),
        '/create_trip_screen': (context) => const CreateTripScreen(),
        '/profile_screen': (context) => const ProfileScreen()
      },
    )
  );
}
