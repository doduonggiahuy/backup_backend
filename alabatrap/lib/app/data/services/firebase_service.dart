import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/api/api_repository/auth_repo.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await _auth.signInWithCredential(authCredential);

        Map<String, dynamic> userData = {
          'ggId': FirebaseAuth.instance.currentUser?.uid,
          'username': FirebaseAuth.instance.currentUser!.displayName,
          'avatar_url': FirebaseAuth.instance.currentUser!.photoURL,
          'email': FirebaseAuth.instance.currentUser!.email,
          'phone': FirebaseAuth.instance.currentUser!.phoneNumber
        };

        AuthApi.loginByGG(userData);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        // Sign in with Firebase using the Facebook credential
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Retrieve the current user's information
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          Map<String, dynamic> userData = {
            'fbId': currentUser.uid,
            'username': currentUser.displayName,
            'avatar_url': currentUser.photoURL,
            'email': currentUser.email,
            'phone': currentUser.phoneNumber
          };

          // Send the user data to your API
          AuthApi.loginByFB(userData);
        }
      } else {
        debugPrint('Facebook login failed: ${loginResult.message}');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  facebookSignOut() async {
    await _auth.signOut();
    await FacebookAuth.instance.logOut();
  }
}
