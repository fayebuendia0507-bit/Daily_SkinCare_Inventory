# Daily SkinCare Inventory

## Backend layer

`lib/backend/` contains screen-focused Dart services for Login, Sign Up,
Inventory, Product Details, Add/Edit Product, Alerts, and Profile. They share
product and profile models plus repository contracts so UI screens can call the
same underlying data rather than duplicating business rules.

The included product and profile repositories are in-memory demo implementations
seeded with the examples from the Stitch screens. Their changes reset when the
app restarts. Replace them with persistent storage or an API-backed
`ProductRepository`/`ProfileRepository` for production use.

Authentication is intentionally an `AuthRepository` contract only. Provide a
real authentication implementation to `SkincareBackend`; this project does not
store passwords or claim to authenticate users locally.

Run the backend tests with `flutter test test/backend_test.dart`.
