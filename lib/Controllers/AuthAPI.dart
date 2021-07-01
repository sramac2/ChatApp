import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Models/User.dart' as models;

class AuthAPI {
  Future<String> loginUserEmailPass(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      }
    }
    return null;
  }

  Future<String> registerEmailPass(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> logout() async {
    await FirebaseAuth.instance.signOut();
    return null;
  }

  Future<String> createUser(models.User user, String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(uid)
        .set(user.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
  }
}
