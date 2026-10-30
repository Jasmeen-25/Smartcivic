// Code is Excited from Chatgpt and modified by the team.
import 'package:flutter/material.dart';
import 'package:smartcivic/constants/report_status.dart';
import 'admin_report_service.dart';
import 'complaint_detail.dart';
import 'widgets/complaint_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminReportService _service = AdminReportService();
  late final Stream<List<Map<String, dynamic>>> _reportsStream;

  @override
  void initState() {
    super.initState();
    // Open the live connection once.
    _reportsStream = _service.watchAllReports();
  }

  int _countStatus(List<Map<String, dynamic>> reports, String status) {
    return reports.where((r) => r['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _reportsStream,
      builder: (context, snapshot) {
        final List<Map<String, dynamic>>? reports = snapshot.data;

        // Shows '—' until real data has loaded.
        String countText(String? status) {
          if (reports == null) return '—';
          if (status == null) return reports.length.toString();
          return _countStatus(reports, status).toString();
        }

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

              // Dashboard summary cards (real counts)
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Reports',
                      value: countText(null),
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Pending',
                      value: countText(ReportStatus.pending),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Verified',
                      value: countText(ReportStatus.verified),
                      icon: Icons.verified,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Repaired',
                      value: countText(ReportStatus.repaired),
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

              ..._buildComplaints(context, snapshot),

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
      },
    );
  }

  // Builds the complaint list, or a loading / error / empty message.
  List<Widget> _buildComplaints(
    BuildContext context,
    AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
  ) {
    if (snapshot.hasError) {
      return [
        _messageBox(
          Icons.error_outline,
          Colors.red,
          'Could not load complaints',
          '${snapshot.error}',
        ),
      ];
    }

    if (!snapshot.hasData) {
      return [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final reports = snapshot.data!;

    if (reports.isEmpty) {
      return [
        _messageBox(
          Icons.assignment_outlined,
          Colors.grey,
          'No complaints yet',
          'New complaints will appear here when citizens submit them.',
        ),
      ];
    }

    return reports.map((report) {
      final dynamic image = report['imageUrl'];
      return ComplaintCard(
        complaintId: report['reportId'].toString(),
        damageType: (report['damageType'] ?? 'Not provided').toString(),
        location: '${report['latitude']}, ${report['longitude']}',
        severity: (report['severity'] ?? 'Not provided').toString(),
        status: (report['status'] ?? 'unknown').toString(),
        imageUrl: image is String ? image : null,
        onViewDetails: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComplaintDetail(complaint: report),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _messageBox(
    IconData icon,
    Color color,
    String title,
    String message,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
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