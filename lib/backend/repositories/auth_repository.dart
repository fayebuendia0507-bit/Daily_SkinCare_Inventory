import '../models/user_profile.dart';

abstract interface class AuthRepository {
  Future<UserProfile> signIn({
    required String email,
    required String password,
  });

  Future<UserProfile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});
  Future<void> signOut();
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);

  final String message;

  @override
  String toString() => message;
}
