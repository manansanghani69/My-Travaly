import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user.dart' as domain;

class UserModel extends domain.User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromGoogleUser(GoogleSignInAccount account) {
    return UserModel(
      id: account.id,
      email: account.email,
      displayName: account.displayName ?? account.email,
      photoUrl: account.photoUrl,
    );
  }

  factory UserModel.fromFirebaseUser(firebase.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email ?? '',
      photoUrl: user.photoURL,
    );
  }
}
