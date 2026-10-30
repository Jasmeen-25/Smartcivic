
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'camera_screen.dart';
import '../features/auth/auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Smart Civic 🌱',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Make Your City Cleaner!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Report waste. Take action. Earn rewards.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A Cleaner Tomorrow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Together, let us build a greener city.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 55,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _menuCard(
              icon: Icons.camera_alt,
              title: 'Report Garbage',
              subtitle: 'Capture waste and report it',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CameraScreen(),
                  ),
                );
              },
            ),

            _menuCard(
              icon: Icons.location_on,
              title: 'Nearby Garbage',
              subtitle: 'Find reported waste locations',
              onTap: () {},
            ),

            _menuCard(
              icon: Icons.stars,
              title: 'Smart Rewards',
              subtitle: 'Check your earned points',
              onTap: () {},
            ),

            _menuCard(
              icon: Icons.person,
              title: 'My Profile',
              subtitle: 'Manage your account',
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (user == null) {
                        return const AuthScreen();
                      }
                      return const ProfileScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 13),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(
            icon,
            color: Colors.green.shade800,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

// PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(
              child: Text('Please login to view your profile.'),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),

                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFC8E6C9),
                    child: Icon(
                      Icons.person,
                      size: 65,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Welcome to Smart Civic!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: Colors.green,
                      ),
                      title: const Text('Email Address'),
                      subtitle: Text(user.email ?? 'Not available'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(
                        Icons.verified_user,
                        color: Colors.green,
                      ),
                      title: const Text('Firebase User ID'),
                      subtitle: SelectableText(user.uid),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        if (!context.mounted) return;

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out successfully.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
