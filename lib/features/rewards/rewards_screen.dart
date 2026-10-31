
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const Color navy = Color(0xFF10243A);
  static const Color teal = Color(0xFF16B8A6);
  static const Color background = Color(0xFFF3F7FB);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please login to view rewards.'));
    }

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() ?? {};
            final points = (data['rewardPoints'] as num?)?.toInt() ?? 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Rewards',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your contributions make your city better!',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 24),

                  // Points card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [navy, Color(0xFF1D4965)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.stars_rounded,
                                color: Color(0xFFFFD166), size: 28),
                            SizedBox(width: 10),
                            Text(
                              'TOTAL REWARD POINTS',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '$points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Keep contributing to earn more!',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24),
                        const Row(
                          children: [
                            Icon(Icons.volunteer_activism,
                                color: teal, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Every responsible action counts.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Next milestone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: navy,
                              ),
                            ),
                            Text(
                              '${points % 100}/100 points',
                              style: const TextStyle(
                                color: teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: (points % 100) / 100,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFE8EEF3),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(teal),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Earn points by participating in civic activities.',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    'Ways to Earn Rewards',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _rewardTile(
                    Icons.report_problem_outlined,
                    'Report civic issues',
                    'Help authorities identify local problems.',
                    '+ Points',
                  ),
                  _rewardTile(
                    Icons.check_circle_outline,
                    'Verify resolved issues',
                    'Confirm when a reported issue is fixed.',
                    '+ Points',
                  ),
                  _rewardTile(
                    Icons.groups_outlined,
                    'Community participation',
                    'Take part in making your city better.',
                    '+ Points',
                  ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F7F4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: teal, size: 25),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Rewards are based on verified activities. '
                            'Your points balance updates from your account.',
                            style: TextStyle(
                              color: navy,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _rewardTile(
    IconData icon,
    String title,
    String subtitle,
    String points,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F7F4),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: teal, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              color: teal,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
