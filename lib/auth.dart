import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';



class Auth{
  // asynchronous method that on completion will return a string
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
}