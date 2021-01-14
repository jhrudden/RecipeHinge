import 'package:firebase_auth/firebase_auth.dart';

import '../../infrastructure/overall/repositories/database.dart';

//TODO: rework authentication to follow some sort of bloc design
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// gets the current changes to authState when user either signs in or out
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Attempt to sign in, if possible
  Future<User> signInUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user.emailVerified) {
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // sign up user
  Future<User> registerUserWithEmailAndPassword(
      {String displayName, String email, String password}) async {
    try {
      print(displayName);
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      try {
        await DatabaseService(uid: user.uid)
            .buildUserDataService()
            .buildUser(displayName);
        // await user.sendEmailVerification();
        return user;
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  /// attempt to sign out user
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  // reset the password connected to the given email
  Future<void> resetPassword({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
