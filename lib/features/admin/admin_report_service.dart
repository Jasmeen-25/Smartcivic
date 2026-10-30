import 'package:cloud_firestore/cloud_firestore.dart';

/// Reads complaints for the admin dashboard.
///
/// It returns raw Firestore data (not the team's Report class), so extra
/// fields such as assignedTeam or aiResult are not lost.
/// Collection name 'reports' matches the team's ReportService.
class AdminReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collection = 'reports';

  /// Live list of ALL reports, newest first.
  Stream<List<Map<String, dynamic>>> watchAllReports() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        // The team stores the document ID in 'reportId'.
        // If it is missing, fall back to the real document ID.
        data['reportId'] = (data['reportId'] ?? doc.id).toString();
        return data;
      }).toList();
    });
  }
}