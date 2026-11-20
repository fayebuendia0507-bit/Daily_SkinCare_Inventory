import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/profile_repository.dart';

class ProfileSummary {
  const ProfileSummary({
    required this.profile,
    required this.productCount,
    required this.activeCategoryCount,
  });

  final UserProfile profile;
  final int productCount;
  final int activeCategoryCount;
}

class ProfileBackend {
  ProfileBackend(this._profiles, this._products, this._auth);

  final ProfileRepository _profiles;
  final ProductRepository _products;
  final AuthRepository _auth;

  Future<ProfileSummary> loadSummary() async {
    final profile = await _profiles.getProfile();
    final products = await _products.getAll();
    final categories = products.map((product) => product.category).toSet();
    return ProfileSummary(
      profile: profile,
      productCount: products.length,
      activeCategoryCount: categories.length,
    );
  }

  Future<UserProfile> updateProfile(UserProfile profile) {
    if (profile.firstName.trim().isEmpty ||
        profile.lastName.trim().isEmpty ||
        !_isValidEmail(profile.email.trim())) {
      throw const FormatException(
        'Enter a first name, last name, and valid email address.',
      );
    }
    return _profiles.updateProfile(
      profile.copyWith(
        firstName: profile.firstName.trim(),
        lastName: profile.lastName.trim(),
        email: profile.email.trim(),
      ),
    );
  }

  Future<void> logout() => _auth.signOut();
}

bool _isValidEmail(String email) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
