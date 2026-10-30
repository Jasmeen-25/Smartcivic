
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the currently logged-in user's ID.
  String? get currentUserId => _auth.currentUser?.uid;

  // Listen to complaints submitted by the logged-in user.
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyComplaints() {
    final userId = currentUserId;

    if (userId == null) {
      return Stream.error('Please log in to view your complaints.');
    }

return _firestore
    .collection('reports')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .snapshots();
  }

  // Listen to updates for a specific complaint.
  Stream<DocumentSnapshot<Map<String, dynamic>>> getComplaintDetails(
    String complaintId,
  ) {
    return _firestore
        .collection('reports')
        .doc(complaintId)
        .snapshots();
  }
}
