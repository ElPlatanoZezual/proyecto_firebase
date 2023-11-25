import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await account!.authentication;
      final AuthCredential credencial = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebaseUser = (await auth.signInWithCredential(credencial)).user;
      await db.collection("users").doc(firebaseUser?.uid).set({
        'correoElectronico': firebaseUser?.email,
        'nombre': firebaseUser?.displayName,
        'id': firebaseUser?.uid,
        'foto': firebaseUser?.photoURL,
      });
    } on FirebaseAuthException catch (e) {
      log('${e.message}');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }
}
