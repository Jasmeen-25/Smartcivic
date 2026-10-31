
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';
import 'report_details_screen.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    const navy = Color(0xFF0B1F3A);
    const cyan = Color(0xFF00D4FF);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Reports'),
          backgroundColor: navy,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Please login to view your reports.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong while loading reports.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: cyan),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
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
                    'No reports found yet.',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text('Your submitted reports will appear here.'),
                ],
              ),
            );
          }

          final reports = documents.map((doc) {
            final data = doc.data();

            // Use the Firestore document ID as a fallback.
            data['reportId'] ??= doc.id;

            return Report.fromMap(data);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: CircleAvatar(
                    backgroundColor: cyan.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.delete_outline,
                      color: navy,
                    ),
                  ),
                  title: Text(
                    report.damageType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Severity: ${report.severity}'),
                        const SizedBox(height: 5),
                        Text(
                          'Status: ${report.status.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailsScreen(
                          report: report,
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
    );
  }
}
