
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/report_model.dart';
import 'report_service.dart';

class ReportSubmissionService {
  Uint8List? reportImage;
  double? latitude;
  double? longitude;

  // Create backend service only when needed.
  ReportService? _reportService;

  ReportService get reportService {
    return _reportService ??= ReportService();
  }

  // Store image and GPS coordinates.
  void createReport({
    required Uint8List image,
    required double lat,
    required double lng,
  }) {
    reportImage = image;
    latitude = lat;
    longitude = lng;
  }

  // Check report readiness.
  bool get isReportReady {
    return reportImage != null &&
        latitude != null &&
        longitude != null;
  }

  // Submit complaint to Firestore.
  Future<String> submitReport({
    required String damageType,
    required String severity,
  }) async {
    if (!isReportReady) {
      throw Exception(
        'Please select an image and capture GPS location.',
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception(
        'Please login before submitting a report.',
      );
    }

    final report = Report(
      reportId: '',
      userId: user.uid,
      imageUrl: null,
      damageType: damageType,
      severity: severity,
      latitude: latitude!,
      longitude: longitude!,
      status: 'pending',
      createdAt: null,
      rewardCredited: false,
    );

    final reportId = await reportService.submitReport(report);

    // Clear temporary data after successful submission.
    reportImage = null;
    latitude = null;
    longitude = null;

    return reportId;
  }
}
