import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Color(0xFFdbd3f6),
    title: Text(
      title,
      style: TextStyle(color: Color(0xFF1d4ed8), fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(Icons.explore, color: Color(0xFF3852b1)),
      ),
    ],
  );
}
