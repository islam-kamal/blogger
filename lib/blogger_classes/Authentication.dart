import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplemention{
  Future<String> Signin(String email,String password);
  Future<String> SignUp(String email,String password);
  Future<String> getCurrentUser();
  Future<void> SignOut();
}

class Auth implements AuthImplemention{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<String> Signin (String email,String password) async
  {
    print("test 11-1-1");
    FirebaseUser user=(await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    print("test 11-1-2");
    return user.uid;

  }

  Future<String> SignUp(String email,String password) async
  {
    FirebaseUser user=(await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }
  Future<String> getCurrentUser()async
  {
    FirebaseUser user=await _firebaseAuth.currentUser();
    return user.uid;
  }
  Future<void> SignOut( ) async
  {
    print("test 1-1");
   _firebaseAuth.signOut();
    print("test 1-2");
  }

}