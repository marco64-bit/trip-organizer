import 'package:flutter/material.dart';
import 'package:trip_organizer/views/app_bar_component.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Profile"),
      body: Center(child: Text("Profile Screen"),),
    );
  }
}
