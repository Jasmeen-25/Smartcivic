
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';
import '../constants/report_status.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'reports';

  // 1. Submit a new complaint.
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

  // 2. Get all reports submitted by a particular user.
  Future<List<Report>> getMyReports(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data()))
        .toList();
  }

  // 3. Get a particular report by its ID.
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

  // 4. Update the status of a report.
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

  // 5. Listen to a user's reports in real time.
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
