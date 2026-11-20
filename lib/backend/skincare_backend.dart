import 'models/user_profile.dart';
import 'repositories/auth_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/profile_repository.dart';
import 'screens/alerts_backend.dart';
import 'screens/inventory_backend.dart';
import 'screens/login_backend.dart';
import 'screens/product_details_backend.dart';
import 'screens/product_form_backend.dart';
import 'screens/profile_backend.dart';
import 'screens/sign_up_backend.dart';

class SkincareBackend {
  SkincareBackend({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    ProductRepository? productRepository,
  }) : products =
           productRepository ?? InMemoryProductRepository.withDemoData() {
    login = LoginBackend(authRepository);
    signUp = SignUpBackend(authRepository);
    inventory = InventoryBackend(products);
    productDetails = ProductDetailsBackend(products);
    productForm = ProductFormBackend(products);
    alerts = AlertsBackend(products);
    profile = ProfileBackend(profileRepository, products, authRepository);
  }

  final ProductRepository products;
  late final LoginBackend login;
  late final SignUpBackend signUp;
  late final InventoryBackend inventory;
  late final ProductDetailsBackend productDetails;
  late final ProductFormBackend productForm;
  late final AlertsBackend alerts;
  late final ProfileBackend profile;
}

ProfileRepository createDemoProfileRepository() => InMemoryProfileRepository(
  UserProfile(
    id: 'demo-user',
    firstName: 'Aoi',
    lastName: 'Tanaka',
    email: 'aoi.tanaka@example.com',
    memberSince: DateTime(2024, 1, 1),
  ),
);
