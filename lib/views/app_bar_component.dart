import 'package:flutter/material.dart';

/// A component that provides a standardized [AppBar] for the application.
/// 
/// [context] is used for theme and navigation context.
/// [title] is the text displayed in the center of the app bar.
PreferredSizeWidget getAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: const Color(0xFFdbd3f6),
    title: Text(
      title,
      style: const TextStyle(color: Color(0xFF1d4ed8), fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: const [
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.explore, color: Color(0xFF3852b1)),
      ),
    ],
  );
}
