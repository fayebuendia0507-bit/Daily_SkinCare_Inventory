import '../models/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
}

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository(this._profile);

  UserProfile _profile;

  @override
  Future<UserProfile> getProfile() async => _profile;

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    _profile = profile;
    return _profile;
  }
}
