
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportId;
  final String userId;
  final String? imageUrl;
  final String damageType;
  final String severity;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;
  final bool rewardCredited;

  Report({
    required this.reportId,
    required this.userId,
    this.imageUrl,
    required this.damageType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
    this.createdAt,
    this.rewardCredited = false,
  });

  // Convert Report object into Firestore data.
  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'userId': userId,
      'imageUrl': imageUrl,
      'damageType': damageType,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'rewardCredited': rewardCredited,
    };
  }

  // Convert Firestore data into Report object.
  factory Report.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return Report(
      reportId: map['reportId'] ?? '',
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'],
      damageType: map['damageType'] ?? '',
      severity: map['severity'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : null,
      rewardCredited: map['rewardCredited'] ?? false,
    );
  }
}
