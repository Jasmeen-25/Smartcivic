
import 'package:flutter/material.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final String complaintId;
  final String title;
  final String location;
  final String status;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaintId,
    required this.title,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Complaint Submitted',
      'Verified by Admin',
      'Assigned to Repair Team',
      'Repair Completed',
    ];

    final descriptions = [
      'Your complaint has been received.',
      'The complaint has been checked by the admin.',
      'A repair team has been assigned.',
      'The reported issue has been resolved.',
    ];

    final statusIndex = {
      'Pending': 0,
      'Verified': 1,
      'Assigned': 2,
      'Repaired': 3,
    }[status] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: const Color(0xFF087F5B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaintId,
                      style: const TextStyle(
                        color: Color(0xFF087F5B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Location: $location'),
                    const SizedBox(height: 12),
                    Chip(label: Text(status)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Complaint Progress',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(steps.length, (index) {
              final completed = index <= statusIndex;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: completed
                            ? const Color(0xFF087F5B)
                            : Colors.grey,
                        size: 28,
                      ),
                      if (index != steps.length - 1)
                        Container(
                          width: 2,
                          height: 55,
                          color: completed
                              ? const Color(0xFF087F5B)
                              : Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: completed
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            descriptions[index],
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
