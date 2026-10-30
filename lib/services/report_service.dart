
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';
import '../constants/report_status.dart';

class ReportService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'reports';

  // Submit a new complaint
  Future<String> submitReport(Report report) async {
    final docRef = _firestore.collection(_collection).doc();

    final newReport = Report(
      reportId: docRef.id,
      userId: report.userId,
      imageUrl: report.imageUrl,
      damageType: report.damageType,
      severity: report.severity,
      latitude: report.latitude,
      longitude: report.longitude,
      status: ReportStatus.pending,
      createdAt: report.createdAt,
      rewardCredited: false,
    );

    await docRef.set(newReport.toMap());

    return docRef.id;
  }

  // Get all reports submitted by a user
  Future<List<Report>> getMyReports(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data()))
        .toList();
  }

  // Get a report by ID
  Future<Report?> getReportById(String reportId) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(reportId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return Report.fromMap(doc.data()!);
  }

  // Update report status
  Future<void> updateReportStatus(
    String reportId,
    String newStatus,
  ) async {
    if (!ReportStatus.all.contains(newStatus)) {
      throw ArgumentError('Invalid report status: $newStatus');
    }

    await _firestore
        .collection(_collection)
        .doc(reportId)
        .update({'status': newStatus});
  }

  // Listen to user's reports in real time
  Stream<List<Report>> watchMyReports(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Report.fromMap(doc.data()))
              .toList(),
        );
  }
}
