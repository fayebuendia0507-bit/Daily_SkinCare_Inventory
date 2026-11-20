import 'package:flutter_test/flutter_test.dart';

import 'package:dailyskincare/backend/models/product.dart';
import 'package:dailyskincare/backend/models/product_alert.dart';
import 'package:dailyskincare/backend/models/user_profile.dart';
import 'package:dailyskincare/backend/repositories/auth_repository.dart';
import 'package:dailyskincare/backend/repositories/product_repository.dart';
import 'package:dailyskincare/backend/screens/alerts_backend.dart';
import 'package:dailyskincare/backend/screens/product_form_backend.dart';
import 'package:dailyskincare/backend/screens/sign_up_backend.dart';

void main() {
  group('screen backends', () {
    test(
      'demo inventory produces expiring, expired, and low-stock alerts',
      () async {
        final today = DateTime(2026, 11, 18);
        final repository = InMemoryProductRepository.withDemoData(now: today);
        final backend = AlertsBackend(repository);

        final alerts = await backend.loadAlerts(today: today);

        expect(
          alerts.where((alert) => alert.type == ProductAlertType.expiringSoon),
          hasLength(2),
        );
        expect(
          alerts.where((alert) => alert.type == ProductAlertType.expired),
          hasLength(1),
        );
        expect(
          alerts.where((alert) => alert.type == ProductAlertType.lowStock),
          hasLength(1),
        );
      },
    );

    test('product form rejects invalid quantity without writing', () async {
      final repository = InMemoryProductRepository();
      final backend = ProductFormBackend(repository);

      await expectLater(
        backend.save(
          input: ProductFormInput(
            name: 'Cleanser',
            brand: 'Example',
            category: ProductCategory.cleanser,
            quantity: -1,
            price: 10,
            expirationDate: DateTime(2027, 1, 1),
          ),
        ),
        throwsFormatException,
      );
      expect(await repository.getAll(), isEmpty);
    });

    test('sign-up validates before delegating credentials', () async {
      final auth = _FakeAuthRepository();
      final backend = SignUpBackend(auth);

      await expectLater(
        backend.register(
          firstName: 'Aoi',
          lastName: 'Tanaka',
          email: 'aoi@example.com',
          password: 'short',
          confirmPassword: 'short',
        ),
        throwsFormatException,
      );
      expect(auth.registerCalls, 0);

      await backend.register(
        firstName: ' Aoi ',
        lastName: 'Tanaka',
        email: 'aoi@example.com',
        password: 'safe-pass-123',
        confirmPassword: 'safe-pass-123',
      );
      expect(auth.registerCalls, 1);
      expect(auth.lastRegisteredFirstName, 'Aoi');
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  int registerCalls = 0;
  String? lastRegisteredFirstName;

  @override
  Future<UserProfile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    registerCalls++;
    lastRegisteredFirstName = firstName;
    return UserProfile(
      id: 'test-user',
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async => UserProfile(
    id: 'test-user',
    firstName: 'Test',
    lastName: 'User',
    email: email,
  );

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {}
}
