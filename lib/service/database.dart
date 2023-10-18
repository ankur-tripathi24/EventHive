import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhive/services/auth/auth_service.dart';

class DatabaseService {
  // final CollectionReference userCollection =
  //     FirebaseFirestore.instance.collection('users');

  // Future<void> updateUserData(String name, String email) async {
  //   try {
  //     await userCollection.doc(uid).set({
  //       'name': name,
  //       'email': email,
  //     });
  //     print('User data updated in Firestore');
  //   } catch (e) {
  //     print('Error updating user data in Firestore: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>?>> getHackathons() async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('hackathons');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get() as QuerySnapshot<Map<String, dynamic>>;

      List<Map<String, dynamic>?> data = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>?> document) {
        data.add({'id': document.id, ...?document.data()});
      });

      return data;
    } catch (e) {
      print("Error fetching data: $e");
      return []; // Return an empty list or handle the error accordingly
    }
  }

  Future<void> registerTeam(
      String teamName, List teamMembers, String hackathonId) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('hackathons');

      await collection.doc(hackathonId).collection('teams').add({
        'teamName': teamName,
        'teamMembers': teamMembers,
      });
    } catch (e) {
      print("Error registering team: $e");
    }
  }

  Future<List<String>> getUserIds(List<String> email) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get() as QuerySnapshot<Map<String, dynamic>>;

      List<String> data = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>?> document) {
        if (email.contains(document.data()?['email'])) {
          data.add(document.id);
        }
      });

      return data;
    } catch (e) {
      print("Error fetching data: $e");
      return []; // Return an empty list or handle the error accordingly
    }
  }

  Future<void> makeRegisterForHackathonTrue(
      List<String> ids, String hackathonId) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');

      ids.forEach((id) async {
        await collection.doc(id).update({
          'registeredForHackathon': true,
          'hackathonIds': FieldValue.arrayUnion([hackathonId])
        });
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  Future<List<Map<String, dynamic>?>> getRegisteredHackathons() async {
    try {
      final currentUser = AuthService.firebase().currentUser;
      final hackathonsIds = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.id)
          .get();

      // data.add(hackathons.data());
      List<Map<String, dynamic>?> data = [];
      for (var i = 0; i < hackathonsIds.data()?['hackathonIds'].length; i++) {
        final hackathons = await FirebaseFirestore.instance
            .collection('hackathons')
            .doc(hackathonsIds.data()?['hackathonIds'][i])
            .get();
        print(hackathons.data());
        data.add(hackathons.data());
      }
      // await FirebaseFirestore.instance
      //     .collection('hackathons')
      //     .doc(hackathonsIds.data()?['hackathonIds'])
      //     .get();
      // print(hackathonsIds.data());
      // print(hackathons.data());

      return data;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<String> getNameFromEmail(String email) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get() as QuerySnapshot<Map<String, dynamic>>;

      List<String> data = [];

      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>?> document) {
        if (email == document.data()?['email']) {
          data.add(document.data()?['name']);
        }
      });

      return data[0];
    } catch (e) {
      print("Error fetching data: $e");
      return ''; // Return an empty list or handle the error accordingly
    }
  }
}
