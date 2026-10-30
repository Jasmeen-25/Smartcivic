
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../rewards/rewards_screen.dart';

const navy = Color(0xFF10243A);
const teal = Color(0xFF16B8A6);
const background = Color(0xFFF3F7FB);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void changeTab(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboard(onSelect: changeTab),
      const FeaturePage(
        icon: Icons.camera_alt_rounded,
        title: 'Report an Issue',
        subtitle: 'Help improve your neighbourhood by reporting civic problems.',
      ),
      const FeaturePage(
        icon: Icons.track_changes_rounded,
        title: 'My Complaints',
        subtitle: 'Your reported complaints will be available here.',
      ),
      const RewardsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: background,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: const Color(0xFFD9F6F0),
        selectedIndex: selectedIndex,
        onDestinationSelected: changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: teal),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_a_photo_outlined),
            selectedIcon: Icon(Icons.add_a_photo, color: teal),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: teal),
            label: 'Complaints',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard, color: teal),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: teal),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  final ValueChanged<int> onSelect;

  const HomeDashboard({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.location_city_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SMARTCIVIC',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Building better communities',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: navy,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Hello, Citizen! 👋',
                      style: TextStyle(
                        color: navy,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Your city. Your voice. Your impact.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Hero banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF10243A),
                            Color(0xFF145B68),
                            Color(0xFF138F83),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: teal.withValues(alpha: 0.18),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -12,
                            top: -15,
                            child: Icon(
                              Icons.public_rounded,
                              size: 125,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '✦  MAKE A DIFFERENCE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 19),
                              const Text(
                                'Let’s Build a\nSmarter City.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 29,
                                  height: 1.2,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'One small report can create a big change.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 22),
                              ElevatedButton(
                                onPressed: () => onSelect(1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB8F4E8),
                                  foregroundColor: navy,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_circle_outline, size: 19),
                                    SizedBox(width: 9),
                                    Text(
                                      'Report an Issue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Dashboard stats
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Impact',
                          style: TextStyle(
                            color: navy,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Community dashboard',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: const [
                        Expanded(
                          child: StatCard(
                            icon: Icons.assignment_turned_in_rounded,
                            value: '—',
                            label: 'My Reports',
                            color: Color(0xFF3985D6),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.check_circle_rounded,
                            value: '—',
                            label: 'Resolved',
                            color: Color(0xFF16A78D),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.stars_rounded,
                            value: '—',
                            label: 'Points',
                            color: Color(0xFFE5A13A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Explore SmartCivic',
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Everything you need, in one place.',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 17),

                    ActionTile(
                      icon: Icons.camera_alt_rounded,
                      title: 'Report a Civic Issue',
                      subtitle: 'Roads, garbage, water and more',
                      color: const Color(0xFF168F83),
                      onTap: () => onSelect(1),
                    ),
                    const SizedBox(height: 12),
                    ActionTile(
                      icon: Icons.track_changes_rounded,
                      title: 'Track Your Complaints',
                      subtitle: 'Check your complaint status',
                      color: const Color(0xFF4778C7),
                      onTap: () => onSelect(2),
                    ),
                    const SizedBox(height: 12),
                    ActionTile(
                      icon: Icons.card_giftcard_rounded,
                      title: 'Rewards & Benefits',
                      subtitle: 'Explore your citizen rewards',
                      color: const Color(0xFFD99531),
                      onTap: () => onSelect(3),
                    ),
                    const SizedBox(height: 25),

                    // Bottom information banner
                    Container(
                      padding: const EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F5F1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFC7EAE2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.volunteer_activism_rounded,
                            size: 34,
                            color: Color(0xFF138F83),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Be the change!',
                                  style: TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Your participation makes your community stronger.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 49,
                width: 49,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black38,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeaturePage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF5EF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, size: 55, color: teal),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
