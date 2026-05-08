import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trip_organizer/views/app_bar_component.dart';
import 'package:trip_organizer/views/app_drawer.dart';
import 'package:trip_organizer/views/create_trip_screen.dart';
import 'package:trip_organizer/views/home_screen.dart';
import 'package:trip_organizer/views/profile_screen.dart';

/// The main navigation hub of the application that manages a [Scaffold] with a bottom bar.
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  /// The index of the currently selected screen in the bottom navigation bar.
  int _selectedIndex = 0;

  /// The unique ID of the currently logged-in user.
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  /// List of main screens accessible via the bottom navigation bar.
  late final List<Widget> _screens = [
    const HomeScreen(),
    CreateTripScreen(userId: _userId),
    const Center(child: Text("Itinerary")),
    const Center(child: Text("Budget")),
    const ProfileScreen(),
  ];

  /// List of titles corresponding to each screen for display in the app bar.
  final List<String> _titles = [
    "Home",
    "Create Trip",
    "Itinerary",
    "Budget",
    "Profile",
  ];

  /// Updates the selected screen index and closes the side drawer.
  /// 
  /// [index] is the new index to be selected.
  void changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Dynamic App Bar that updates based on the current selection.
      appBar: getAppBar(
        context,
        _titles[_selectedIndex],
      ),

      /// Custom side drawer for additional navigation options.
      drawer: AppDrawer(
        onItemSelected: changePage,
      ),

      /// The body of the scaffold displaying the currently selected screen.
      body: _screens[_selectedIndex],

      /// Floating Action Button shown only on the Home screen to quickly navigate to "Plan".
      floatingActionButton: _selectedIndex == 0
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

      /// Bottom navigation bar for switching between primary app screens.
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
