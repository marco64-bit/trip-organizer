import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip_organizer/views/bottom_nav.dart';
import 'package:trip_organizer/views/budget_screen.dart';
import 'package:trip_organizer/views/create_trip_screen.dart';
import 'package:trip_organizer/views/login_screen.dart';
import 'package:trip_organizer/views/profile_screen.dart';
import 'package:trip_organizer/views/register_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Trip Organizer",
      routes: {
        '/': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/bottom_nav': (context) => const BottomNav(),
        '/create_trip_screen': (context) => const CreateTripScreen(userId: '',),
        '/profile_screen': (context) => const ProfileScreen(),
        '/budget_screen': (context) => const BudgetScreen(),
      },
    ),
  );
}
