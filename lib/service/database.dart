import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String email) async {
    try {
      await userCollection.doc(uid).set({
        'name': name,
        'email': email,
      });
      print('User data updated in Firestore');
    } catch (e) {
      print('Error updating user data in Firestore: $e');
    }
  }
}
