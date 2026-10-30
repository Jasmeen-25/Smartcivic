import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getRewardPoints(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists || doc.data() == null) {
      return 0;
    }

    return (doc.data()!['rewardPoints'] as num?)?.toInt() ?? 0;
  }

  Stream<int> watchRewardPoints(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return 0;
        }

        return (snapshot.data()!['rewardPoints'] as num?)?.toInt() ?? 0;
      },
    );
  }

  Future<List<Map<String, dynamic>>> getRedemptions(String userId) async {
    final snapshot = await _firestore
        .collection('redemptions')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}