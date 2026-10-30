
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color profileNavy = Color(0xFF10243A);
const Color profileTeal = Color(0xFF16B8A6);
const Color profileBg = Color(0xFFF3F7FB);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login again.')),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};

        final name = data['name'] ?? user.displayName ?? 'Citizen';
        final email = user.email ?? 'No email available';

        return Scaffold(
          backgroundColor: profileBg,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: profileNavy,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Manage your citizen information',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // Profile header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              profileNavy,
                              Color(0xFF176477),
                              Color(0xFF159D91),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white,
                              child: Text(
                                name.toString().isNotEmpty
                                    ? name.toString()[0].toUpperCase()
                                    : 'C',
                                style: const TextStyle(
                                  color: profileNavy,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              name.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 13),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (data['role'] ?? 'user')
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Rewards card
                      Container(
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1D9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.stars_rounded,
                                color: Color(0xFFE5A13A),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Reward Points',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${data['rewardPoints'] ?? 0} Points',
                                    style: const TextStyle(
                                      color: profileNavy,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.card_giftcard,
                              color: profileTeal,
                              size: 26,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              color: profileNavy,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ProfileEditDialog(
                                  userData: data,
                                  email: email,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 17,
                            ),
                            label: const Text('Edit'),
                            style: TextButton.styleFrom(
                              foregroundColor: profileTeal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      _infoCard([
                        _infoRow(
                          Icons.person_outline,
                          'Full Name',
                          name.toString(),
                        ),
                        _infoRow(
                          Icons.email_outlined,
                          'Email Address',
                          email,
                        ),
                        _infoRow(
                          Icons.phone_outlined,
                          'Phone Number',
                          data['phone'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.cake_outlined,
                          'Date of Birth',
                          data['dateOfBirth'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.wc_outlined,
                          'Gender',
                          data['gender'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.work_outline,
                          'Occupation',
                          data['occupation'] ?? 'Not added',
                        ),
                      ]),

                      const SizedBox(height: 24),

                      const Text(
                        'Address Details',
                        style: TextStyle(
                          color: profileNavy,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _infoCard([
                        _infoRow(
                          Icons.home_outlined,
                          'House / Street',
                          data['address'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.location_city_outlined,
                          'City',
                          data['city'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.map_outlined,
                          'State',
                          data['state'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.pin_drop_outlined,
                          'PIN Code',
                          data['pinCode'] ?? 'Not added',
                        ),
                        _infoRow(
                          Icons.language_outlined,
                          'Preferred Language',
                          data['language'] ?? 'Not added',
                        ),
                      ]),

                      const SizedBox(height: 24),

                      const Text(
                        'Account Information',
                        style: TextStyle(
                          color: profileNavy,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _infoCard([
                        _infoRow(
                          Icons.verified_user_outlined,
                          'Account ID',
                          user.uid,
                        ),
                        _infoRow(
                          Icons.calendar_today_outlined,
                          'Joined On',
                          _formatDate(data['createdAt']),
                        ),
                      ]),

                      const SizedBox(height: 25),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        height: 53,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Logout?'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseAuth.instance.signOut();
                            }
                          },
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text(
                            'Logout from Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(
                              color: Colors.redAccent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: profileTeal, size: 21),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value.toString(),
                  style: const TextStyle(
                    color: profileNavy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Not available';
  }
}

class ProfileEditDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String email;

  const ProfileEditDialog({
    super.key,
    required this.userData,
    required this.email,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {};
  bool saving = false;
  String gender = 'Prefer not to say';
  String language = 'English';

  final fields = const {
    'name': 'Full Name',
    'phone': 'Phone Number',
    'dateOfBirth': 'Date of Birth (DD/MM/YYYY)',
    'occupation': 'Occupation',
    'address': 'House / Street',
    'city': 'City',
    'state': 'State',
    'pinCode': 'PIN Code',
  };

  @override
  void initState() {
    super.initState();

    for (final entry in fields.entries) {
      controllers[entry.key] = TextEditingController(
        text: (widget.userData[entry.key] ?? '').toString(),
      );
    }

    gender = widget.userData['gender'] ?? 'Prefer not to say';
    language = widget.userData['language'] ?? 'English';
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      final updatedData = {
        for (final entry in controllers.entries)
          entry.key: entry.value.text.trim(),
        'gender': gender,
        'language': language,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(updatedData, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: profileTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update profile: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Your Profile',
                style: TextStyle(
                  color: profileNavy,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Update your personal information below.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 20),

              ...fields.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: TextFormField(
                    controller: controllers[entry.key],
                    keyboardType: entry.key == 'phone' ||
                            entry.key == 'pinCode'
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: entry.value,
                      filled: true,
                      fillColor: profileBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: entry.key == 'name'
                        ? (value) => value == null || value.trim().isEmpty
                            ? 'Please enter your name'
                            : null
                        : null,
                  ),
                );
              }),

              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  filled: true,
                  fillColor: profileBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  'Prefer not to say',
                  'Female',
                  'Male',
                  'Other',
                ].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => gender = value);
                },
              ),

              const SizedBox(height: 13),

              DropdownButtonFormField<String>(
                value: language,
                decoration: InputDecoration(
                  labelText: 'Preferred Language',
                  filled: true,
                  fillColor: profileBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  'English',
                  'Hindi',
                  'Punjabi',
                ].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => language = value);
                },
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saving ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: profileNavy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: saving
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
