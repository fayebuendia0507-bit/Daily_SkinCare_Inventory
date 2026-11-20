class UserProfile {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.memberSince,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime? memberSince;

  String get fullName => '$firstName $lastName'.trim();

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? memberSince,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}
