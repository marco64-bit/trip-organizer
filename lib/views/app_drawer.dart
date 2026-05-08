import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {

  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [

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

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Trips"),
            onTap: () => onItemSelected(0),
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Plan"),
            onTap: () => onItemSelected(1),
          ),

          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Itinerary"),
            onTap: () => onItemSelected(2),
          ),

          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Budget"),
            onTap: () => onItemSelected(3),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => onItemSelected(4),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {

              await FirebaseAuth.instance.signOut();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}