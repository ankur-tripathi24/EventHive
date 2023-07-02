import 'package:eventhive/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user != null) {
        await DatabaseService(uid: userCredential.user!.uid)
            .updateUserData(name, email);
      }

      return userCredential;
    } catch (e) {
      // Handle the error here
      print('Error registering user: $e');
      return null;
    }
  }

  Future<UserCredential?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
