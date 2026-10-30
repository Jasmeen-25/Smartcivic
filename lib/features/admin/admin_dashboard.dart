// Code is Excited from Chatgpt and modified by the team.
import 'package:flutter/material.dart';
import 'complaint_detail.dart';
import 'widgets/complaint_card.dart';

// ---------------------------------------------------------------
// DEMONSTRATION DATA ONLY - these are NOT real complaints.
// Keys follow the PROPOSED team schema (not yet confirmed by
// Member 5). Delete this list when Firebase is connected.
// ---------------------------------------------------------------
final List<Map<String, dynamic>> _demoComplaints = [
  {
    'id': 'DEMO-001',
    'damageType': 'Pothole',
    'severity': 'High',
    'description': 'Demo: large pothole near a school gate.',
    'latitude': 12.3456,
    'longitude': 78.9012,
    'status': 'pending',
    'assignedTeam': null,
    'imageUrl': null,
    'aiResult': null,
  },
  {
    'id': 'DEMO-002',
    'damageType': 'Crack',
    'severity': 'Medium',
    'description': 'Demo: long crack along the road edge.',
    'latitude': 12.3460,
    'longitude': 78.9020,
    'status': 'verified',
    'assignedTeam': null,
    'imageUrl': null,
    'aiResult': null,
  },
  {
    'id': 'DEMO-003',
    'damageType': 'Damaged surface',
    'severity': 'Low',
    'description': 'Demo: worn road surface.',
    'latitude': 12.3470,
    'longitude': 78.9030,
    'status': 'repaired',
    'assignedTeam': 'Demo Team A',
    'imageUrl': null,
    'aiResult': null,
  },
];

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Smartcivic Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Monitor and manage road complaints',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Dashboard summary cards
          Row(
            children: const [
              Expanded(
                child: SummaryCard(
                  title: 'Total Reports',
                  value: '—',
                  icon: Icons.assignment,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Pending',
                  value: '—',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: SummaryCard(
                  title: 'Verified',
                  value: '—',
                  icon: Icons.verified,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Repaired',
                  value: '—',
                  icon: Icons.check_circle,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          const Text(
            'Recent Complaints',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Banner so nobody mistakes demo data for real complaints
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: const Text(
              'DEMONSTRATION DATA - these are not real complaints. '
              'Real complaints will load once Firebase is connected.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),

          // One card per demo complaint
          ..._demoComplaints.map((complaint) {
            return ComplaintCard(
              complaintId: complaint['id'].toString(),
              damageType: complaint['damageType'].toString(),
              location: '${complaint['latitude']}, ${complaint['longitude']}',
              severity: complaint['severity'].toString(),
              status: complaint['status'].toString(),
              imageUrl: complaint['imageUrl'] as String?,
              onViewDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComplaintDetail(complaint: complaint),
                  ),
                );
              },
            );
          }),

          const SizedBox(height: 10),

          const Text(
            'AI Road Damage Detection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.deepPurple,
                  size: 35,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Detection Module',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Road damage predictions will appear here.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}