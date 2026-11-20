import 'dart:math';

import '../models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  Future<Product> create(Product product);
  Future<Product> update(Product product);
  Future<void> delete(String id);
}

class InMemoryProductRepository implements ProductRepository {
  InMemoryProductRepository({Iterable<Product> initialProducts = const []})
      : _products = {
          for (final product in initialProducts) product.id: product,
        };

  factory InMemoryProductRepository.withDemoData({DateTime? now}) =>
      InMemoryProductRepository(initialProducts: demoProducts(now: now));

  final Map<String, Product> _products;

  @override
  Future<List<Product>> getAll() async =>
      List.unmodifiable(_products.values);

  @override
  Future<Product?> getById(String id) async => _products[id];

  @override
  Future<Product> create(Product product) async {
    if (_products.containsKey(product.id)) {
      throw StateError('A product with id "${product.id}" already exists.');
    }
    _products[product.id] = product;
    return product;
  }

  @override
  Future<Product> update(Product product) async {
    if (!_products.containsKey(product.id)) {
      throw StateError('Product "${product.id}" was not found.');
    }
    _products[product.id] = product;
    return product;
  }

  @override
  Future<void> delete(String id) async {
    if (_products.remove(id) == null) {
      throw StateError('Product "$id" was not found.');
    }
  }
}

List<Product> demoProducts({DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  DateTime inDays(int days) => today.add(Duration(days: days));
  DateTime opened(int daysAgo) => today.subtract(Duration(days: daysAgo));

  return [
    Product(
      id: 'product-hyaluronic-acid',
      name: 'Hyaluronic Acid 2% + B5',
      brand: 'The Ordinary',
      category: ProductCategory.serum,
      quantity: 2,
      price: 8.90,
      expirationDate: inDays(180),
      openedAt: opened(30),
      paoMonths: 12,
      routineTags: const ['AM Routine', 'PM Routine'],
    ),
    Product(
      id: 'product-centella-toner',
      name: 'Centella Water Alcohol-Free Toner',
      brand: 'COSRX',
      category: ProductCategory.toner,
      quantity: 1,
      price: 18.00,
      expirationDate: inDays(12),
      openedAt: opened(150),
      paoMonths: 12,
      notes: 'Keep chilled.',
      routineTags: const ['AM Routine'],
    ),
    Product(
      id: 'product-daily-cleanser',
      name: 'Daily Facial Cleanser',
      brand: 'CeraVe',
      category: ProductCategory.cleanser,
      quantity: 1,
      price: 14.50,
      expirationDate: today.subtract(const Duration(days: 90)),
      openedAt: opened(300),
      paoMonths: 12,
    ),
    Product(
      id: 'product-sunscreen',
      name: 'Watery Sun Gel SPF50+',
      brand: 'Isntree',
      category: ProductCategory.sunscreen,
      quantity: 0,
      price: 22.00,
      expirationDate: inDays(45),
    ),
    Product(
      id: 'product-moisturizer',
      name: 'Barrier Restoring Moisturizer',
      brand: 'Aestura',
      category: ProductCategory.moisturizer,
      quantity: 3,
      price: 26.00,
      expirationDate: inDays(120),
      routineTags: const ['PM Routine'],
    ),
    Product(
      id: 'product-vitamin-c',
      name: 'Vitamin C 23% Suspension',
      brand: 'The Ordinary',
      category: ProductCategory.serum,
      quantity: 1,
      price: 10.20,
      expirationDate: inDays(18),
      openedAt: opened(120),
      paoMonths: 6,
      routineTags: const ['AM Routine'],
    ),
    Product(
      id: 'product-snail-essence',
      name: 'Advanced Snail 96 Mucin Power Essence',
      brand: 'COSRX',
      category: ProductCategory.serum,
      quantity: 2,
      price: 24.50,
      expirationDate: inDays(240),
      openedAt: opened(45),
      paoMonths: 18,
      notes: 'Store in a cool, dry place. Patch test done.',
      routineTags: const ['AM Routine', 'PM Routine'],
    ),
    Product(
      id: 'product-gentle-cleanser',
      name: 'Gentle Hydrating Cleanser',
      brand: 'CeraVe',
      category: ProductCategory.cleanser,
      quantity: 1,
      price: 12.00,
      expirationDate: inDays(210),
      routineTags: const ['AM Routine', 'PM Routine'],
    ),
  ];
}

String createProductId() {
  final randomPart = Random.secure().nextInt(1 << 32).toRadixString(16);
  return 'product-${DateTime.now().microsecondsSinceEpoch}-$randomPart';
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
