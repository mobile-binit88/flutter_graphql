import 'package:firebase_auth/firebase_auth.dart';

class FirebaseBaseAuthentication {
  // Login with firebase
  static Future<FirebaseUser> loginAuthentication(
      String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      return null;
    }
  }

  // Registeration with firebase
  static Future<bool> registerAuthentication(
      String email, String password, String name) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      UserUpdateInfo info = UserUpdateInfo();

      info.displayName = name;
      info.photoUrl = "photourl";
      user.updateProfile(info);

      return true;
    } catch (e) {
      return false;
    }
  }
}
