import 'package:ChatApp/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Userr _userFromFirebaseUser(User user) {
    return user != null ? Userr(userId: user.uid) : null;
  }

  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = res.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print("Exception ---- " + e);
    }
  }

  Future signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = res.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print("Exception ---- " + e);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Exception ---- " + e);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Exception ---- " + e);
    }
  }
}
