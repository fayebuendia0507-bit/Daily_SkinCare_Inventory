import '../repositories/auth_repository.dart';

class SignUpBackend {
  SignUpBackend(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final normalizedFirstName = firstName.trim();
    final normalizedLastName = lastName.trim();
    final normalizedEmail = email.trim();

    if (normalizedFirstName.isEmpty || normalizedLastName.isEmpty) {
      throw const FormatException('First and last name are required.');
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw const FormatException('Enter a valid email address.');
    }
    if (password.length < 8) {
      throw const FormatException('Password must be at least 8 characters.');
    }
    if (password != confirmPassword) {
      throw const FormatException('Passwords do not match.');
    }

    await _authRepository.register(
      firstName: normalizedFirstName,
      lastName: normalizedLastName,
      email: normalizedEmail,
      password: password,
    );
  }
}

bool _isValidEmail(String email) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
