
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

class SmartCivicApp extends StatelessWidget {
  const SmartCivicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCivic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
