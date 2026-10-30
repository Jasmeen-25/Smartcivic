
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
  final Map<String, dynamic>? aiResult;
  final String? assignedTeam;

  Report({
    required this.reportId,
    required this.userId,
    this.imageUrl,
    required this.damageType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.createdAt,
    required this.rewardCredited,
    this.aiResult,
    this.assignedTeam,
  });

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
      'aiResult': aiResult,
      'assignedTeam': assignedTeam,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return Report(
      reportId: map['reportId'] ?? '',
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] as String?,
      damageType: map['damageType'] ?? '',
      severity: map['severity'] ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : null,
      rewardCredited: map['rewardCredited'] ?? false,
      aiResult: map['aiResult'] == null
          ? null
          : Map<String, dynamic>.from(map['aiResult']),
      assignedTeam: map['assignedTeam'] as String?,
    );
  }
}
