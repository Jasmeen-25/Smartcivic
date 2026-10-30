
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final int rewardPoints;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.role = 'user',
    this.rewardPoints = 0,
    this.createdAt,
  });

  // Convert UserModel into Firestore data.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'rewardPoints': rewardPoints,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  // Convert Firestore data into UserModel.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      rewardPoints: (map['rewardPoints'] as num?)?.toInt() ?? 0,
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : null,
    );
  }
}
