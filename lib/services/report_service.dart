
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';
import '../constants/report_status.dart';

class ReportService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'reports';

  static const int rewardPoints = 10;

  // Submit report and credit 10 points atomically.
  Future<String> submitReport(Report report) async {
    final docRef = _firestore.collection(_collection).doc();

    final userRef = _firestore
        .collection('users')
        .doc(report.userId);

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
      rewardCredited: true,
      aiResult: report.aiResult,
      assignedTeam: report.assignedTeam,
    );

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw StateError('User profile does not exist.');
      }

      transaction.set(docRef, newReport.toMap());

      transaction.update(userRef, {
        'rewardPoints': FieldValue.increment(rewardPoints),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastRewardReportId': docRef.id,
      });
    });

    return docRef.id;
  }

  // Get user's reports.
  Future<List<Report>> getMyReports(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data()))
        .toList();
  }

  // Get report by ID.
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

  // Update report status.
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

  // Watch user's reports.
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
