// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicly/components/error_snackbar.dart';
import 'package:musicly/main.dart';

class AuthController extends GetxController {
  RxString? _errorCode;
  RxString? get errorCode => _errorCode;
  final RxBool _hasError = false.obs;
  RxBool? get hasError => _hasError;
  User? get user => FirebaseAuth.instance.currentUser;

  Future googleLogin(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showErrorSnackBar(
          title: "Attention", message: "Please Turn On Your Internet");
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) =>
            const Center(child: CircularProgressIndicator())));
    GoogleSignInAccount? googleUser;
    GoogleSignInAuthentication? googleAuth;
    try {
      googleUser = await googleSignIn.signIn();
    } catch (e) {
      print(e.toString());
    }
    if (googleUser == null) {
      Get.back();
      return;
    }
    try {
      googleAuth = await googleUser.authentication;
    } catch (e) {
      print(e.toString());
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final User userDetails =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
      print(userDetails.displayName);
      print(userDetails.email);

      update();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          _errorCode!(
              "You already have an account with us. Use correct provider");
          _hasError(true);
          break;
        case "null":
          _errorCode!("Some unexpected error while trying to sign in");
          _hasError(true);

          break;
        default:
          _errorCode!(e.toString());
          _hasError(true);
      }
    }

    navigatorKey.currentState!.pop();
  }

  // signout
  Future userSignOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
