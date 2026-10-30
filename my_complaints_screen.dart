
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tracking_service.dart';
import 'complaint_details_screen.dart';

class MyComplaintsScreen extends StatelessWidget {
  MyComplaintsScreen({super.key});

  final TrackingService _trackingService = TrackingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        title: const Text(
          'My Complaints',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF087F5B),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track your reports',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Check the latest updates on your complaints.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: _trackingService.getMyComplaints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to load complaints.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final complaints = snapshot.data?.docs ?? [];

                  if (complaints.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 65,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No complaints yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your submitted complaints will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final doc = complaints[index];
                      final data = doc.data();

                      final title =
                          data['damageType']?.toString() ??
                          'Reported Issue';

                      final status =
                          data['status']?.toString() ??
                          'pending';

                      final latitude = data['latitude'];
                      final longitude = data['longitude'];

                      final location =
                          latitude != null && longitude != null
                              ? '$latitude, $longitude'
                              : 'Location unavailable';

                      final timestamp = data['createdAt'];
                      final date = timestamp is Timestamp
                          ? timestamp.toDate().toString().split(' ')[0]
                          : 'Date unavailable';

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${doc.id}\n$location\n$date',
                            ),
                          ),
                          trailing: _statusBadge(status),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ComplaintDetailsScreen(
                                  complaintId: doc.id,
                                  title: title,
                                  location: location,
                                  status: _displayStatus(status),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'Verified';
      case 'assigned':
        return 'Assigned';
      case 'repaired':
        return 'Repaired';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Widget _statusBadge(String status) {
    final normalized = status.toLowerCase();

    Color color;

    switch (normalized) {
      case 'repaired':
        color = Colors.green;
        break;
      case 'assigned':
        color = Colors.blue;
        break;
      case 'verified':
        color = Colors.teal;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _displayStatus(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
