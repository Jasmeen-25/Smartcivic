import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartcivic/firebase_options.dart';
import 'admin_dashboard.dart';

// PREVIEW ONLY: lets me run the admin screens without touching main.dart.
// It starts Firebase the same way the team's main.dart does.
// This file is not part of the real app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    ),
  );
}