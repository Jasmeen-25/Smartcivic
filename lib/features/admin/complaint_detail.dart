// Code is Excited from Claude and modified by the team.
import 'package:flutter/material.dart';
import 'widgets/status_badge.dart';

/// Complaint Details screen for admins.
/// Takes one complaint as a Map. Keys follow the PROPOSED team schema
/// (not yet confirmed by Member 5).
class ComplaintDetail extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintDetail({super.key, required this.complaint});

  // Safely read a value. Shows "Not provided" if it is missing.
  String _text(String key) {
    final value = complaint[key];
    if (value == null || value.toString().trim().isEmpty) {
      return 'Not provided';
    }
    return value.toString();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (complaint['imageUrl'] ?? '').toString();
    final dynamic aiResult = complaint['aiResult'];

    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Photo ----------
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isEmpty
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48),
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // ---------- ID and status ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Complaint ID: ${_text('id')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusBadge(status: _text('status')),
              ],
            ),
            const Divider(height: 32),

            // ---------- Complaint info ----------
            const Text(
              'Complaint Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _infoRow('Damage Type', _text('damageType')),
            _infoRow('Severity', _text('severity')),
            _infoRow('Description', _text('description')),
            _infoRow('Latitude', _text('latitude')),
            _infoRow('Longitude', _text('longitude')),
            _infoRow('Assigned Team', _text('assignedTeam')),
            const Divider(height: 32),

            // ---------- AI section ----------
            const Text(
              'AI Road Damage Detection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (aiResult is Map)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('AI Category', '${aiResult['damageType'] ?? 'Not provided'}'),
                  _infoRow('Confidence', '${aiResult['confidence'] ?? 'Not provided'}'),
                  const Text(
                    'AI assists the admin. It does not approve complaints.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            else
              const Text(
                'AI result not available',
                style: TextStyle(color: Colors.grey),
              ),
            const Divider(height: 32),

            // ---------- Admin actions ----------
            const Text(
              'Admin Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Buttons are not connected to Firebase yet.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showMessage(context, 'Verify: not connected yet'),
                    child: const Text('Verify'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showMessage(context, 'Reject: not connected yet'),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () =>
                    _showMessage(context, 'Assign team: not connected yet'),
                child: const Text('Assign Repair Team'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () =>
                    _showMessage(context, 'Mark repaired: not connected yet'),
                child: const Text('Mark as Repaired'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}