import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class GoogleAuthLocalDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getSignedInUser();
}

class GoogleAuthLocalDataSourceImpl implements GoogleAuthLocalDataSource {
  GoogleAuthLocalDataSourceImpl({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
  }) : _googleSignIn = googleSignIn,
       _firebaseAuth = firebaseAuth;

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final account =
          await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
      if (account == null) {
        throw AuthException('Sign-in cancelled');
      }

      final authentication = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user ?? _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException('Unable to retrieve user information');
      }

      return UserModel.fromFirebaseUser(user);
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (error) {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel.fromFirebaseUser(currentUser);
      }
      throw AuthException(error.message ?? 'Authentication failed');
    } catch (error) {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel.fromFirebaseUser(currentUser);
      }
      throw AuthException(error.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait<dynamic>([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }

  @override
  Future<UserModel?> getSignedInUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(user);
  }
}
