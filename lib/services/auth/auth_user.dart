import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/widgets.dart';
// TODO
// add alias to User - as FirebaseAuth
// FirebaseAuth.User - this is good practice to expose auth providers

@immutable
// decorator for classes that marks them as immutable even when extended
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
