import 'package:flutter/material.dart';
import 'package:trip_organizer/views/app_bar_component.dart';
import 'package:trip_organizer/views/app_drawer.dart';
import 'package:trip_organizer/views/create_trip_screen.dart';
import 'package:trip_organizer/views/home_screen.dart';
import 'package:trip_organizer/views/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CreateTripScreen(userId: '',),
    const Center(child: Text("Itinerary")),
    const Center(child: Text("Budget")),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    "Home",
    "Create Trip",
    "Itinerary",
    "Budget",
    "Profile",
  ];

  void changePage(int index) {


    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: getAppBar(
        context,
        _titles[_selectedIndex],
      ),

      drawer: AppDrawer(
        onItemSelected: changePage,
      ),

      body: _screens[_selectedIndex],
      floatingActionButton:
      _selectedIndex == 0
          ? FloatingActionButton(

        onPressed: () {

          setState(() {
            _selectedIndex = 1;
          });

        },

        backgroundColor: const Color(0xFF1d4ed8),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF1d4ed8),
        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'TRIPS',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'PLAN',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'ITINERARY',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            activeIcon: Icon(Icons.attach_money),
            label: 'BUDGET',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}