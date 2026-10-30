import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

// PREVIEW ONLY: lets me run the admin screens without touching main.dart.
// This file is not part of the real app.
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    ),
  );
}