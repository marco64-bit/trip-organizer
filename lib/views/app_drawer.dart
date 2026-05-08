import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A custom side drawer that provides navigation and user account information.
class AppDrawer extends StatelessWidget {

  /// Callback function triggered when a navigation item is selected.
  /// The integer parameter represents the index of the selected screen.
  final Function(int) onItemSelected;

  /// Creates an [AppDrawer] with the required [onItemSelected] callback.
  const AppDrawer({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    /// Retrieves the current authenticated user from Firebase.
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          /// Header displaying the user's account information.
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1d4ed8),
            ),
            accountName: const Text("Welcome"),
            accountEmail: Text(user?.email ?? "No Email"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),

          /// Navigation item for the "Trips" screen.
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Trips"),
            onTap: () => onItemSelected(0),
          ),

          /// Navigation item for the "Plan" (Create Trip) screen.
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Plan"),
            onTap: () => onItemSelected(1),
          ),

          /// Navigation item for the "Itinerary" screen.
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Itinerary"),
            onTap: () => onItemSelected(2),
          ),

          /// Navigation item for the "Budget" screen.
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Budget"),
            onTap: () => onItemSelected(3),
          ),

          /// Navigation item for the "Profile" screen.
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => onItemSelected(4),
          ),

          const Divider(),

          /// Logout item that signs out the user and navigates to the login screen.
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
