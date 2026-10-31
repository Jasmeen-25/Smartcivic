
import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  static const List<String> statuses = [
    'pending',
    'verified',
    'assigned',
    'repaired',
  ];

  int get currentStep {
    final index = statuses.indexOf(report.status.toLowerCase());
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1F3A);
    const cyan = Color(0xFF00D4FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Report Details'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'REPORT ID',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    report.reportId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    report.status.toUpperCase(),
                    style: const TextStyle(
                      color: cyan,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Report Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _detailTile('Damage Type', report.damageType),
            _detailTile('Severity', report.severity),
            _detailTile(
              'Latitude',
              report.latitude.toStringAsFixed(6),
            ),
            _detailTile(
              'Longitude',
              report.longitude.toStringAsFixed(6),
            ),
            _detailTile(
              'Date',
              report.createdAt == null
                  ? 'Not available'
                  : report.createdAt!.toLocal().toString(),
            ),

            const SizedBox(height: 24),
            const Text(
              'Report Progress',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(statuses.length, (index) {
              final completed = index <= currentStep;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: completed ? Colors.green : Colors.grey,
                        size: 27,
                      ),
                      if (index != statuses.length - 1)
                        Container(
                          width: 2,
                          height: 38,
                          color: completed
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      statuses[index][0].toUpperCase() +
                          statuses[index].substring(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: completed
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: completed ? navy : Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            }),

            if (report.status.toLowerCase() == 'rejected')
              const Text(
                'This report has been rejected.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
