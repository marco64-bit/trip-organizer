import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Color(0xFFdbd3f6),
    leading: Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Icon(Icons.explore, color: Color(0xFF3852b1)),
    ),
    title: Text(
      title,
      style: TextStyle(color: Color(0xFF1d4ed8), fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {},
        icon: const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF1d4ed8),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
      const SizedBox(width: 8),
    ],
  );
}
