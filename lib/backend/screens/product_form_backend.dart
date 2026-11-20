import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductFormInput {
  const ProductFormInput({
    required this.name,
    required this.brand,
    required this.category,
    required this.quantity,
    required this.price,
    required this.expirationDate,
    this.openedAt,
    this.paoMonths,
    this.notes = '',
    this.routineTags = const [],
  });

  final String name;
  final String brand;
  final ProductCategory category;
  final int quantity;
  final double price;
  final DateTime expirationDate;
  final DateTime? openedAt;
  final int? paoMonths;
  final String notes;
  final List<String> routineTags;
}

class ProductFormBackend {
  ProductFormBackend(this._products);

  final ProductRepository _products;

  Future<Product> save({
    String? productId,
    required ProductFormInput input,
  }) async {
    _validate(input);
    final existing =
        productId == null ? null : await _products.getById(productId);
    if (productId != null && existing == null) {
      throw StateError('Product "$productId" was not found.');
    }

    final product = Product(
      id: productId ?? createProductId(),
      name: input.name.trim(),
      brand: input.brand.trim(),
      category: input.category,
      quantity: input.quantity,
      price: input.price,
      expirationDate: input.expirationDate,
      openedAt: input.openedAt,
      paoMonths: input.paoMonths,
      notes: input.notes.trim(),
      routineTags: List.unmodifiable(input.routineTags),
    );

    return existing == null
        ? _products.create(product)
        : _products.update(product);
  }

  void _validate(ProductFormInput input) {
    if (input.name.trim().isEmpty || input.brand.trim().isEmpty) {
      throw const FormatException('Product name and brand are required.');
    }
    if (input.quantity < 0) {
      throw const FormatException('Quantity cannot be negative.');
    }
    if (!input.price.isFinite || input.price < 0) {
      throw const FormatException('Enter a valid non-negative price.');
    }
    if (input.paoMonths != null && input.paoMonths! <= 0) {
      throw const FormatException('PAO must be greater than zero months.');
    }
    if (input.openedAt != null &&
        _dateOnly(input.expirationDate).isBefore(_dateOnly(input.openedAt!))) {
      throw const FormatException(
        'Expiration date cannot be before the opened date.',
      );
    }
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
