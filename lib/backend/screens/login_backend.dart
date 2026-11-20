import '../repositories/auth_repository.dart';

class LoginBackend {
  LoginBackend(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      throw const FormatException('Enter a valid email address.');
    }
    if (password.isEmpty) {
      throw const FormatException('Password is required.');
    }

    await _authRepository.signIn(
      email: normalizedEmail,
      password: password,
    );
  }

  Future<void> requestPasswordReset(String email) async {
    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      throw const FormatException('Enter a valid email address.');
    }
    await _authRepository.requestPasswordReset(email: normalizedEmail);
  }
}

bool _isValidEmail(String email) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
