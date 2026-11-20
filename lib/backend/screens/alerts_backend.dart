import '../models/product.dart';
import '../models/product_alert.dart';
import '../repositories/product_repository.dart';

class AlertsBackend {
  AlertsBackend(this._products);

  final ProductRepository _products;

  Future<List<ProductAlert>> loadAlerts({
    ProductAlertFilter filter = ProductAlertFilter.all,
    DateTime? today,
  }) async {
    final date = _dateOnly(today ?? DateTime.now());
    final alerts = <ProductAlert>[];

    for (final product in await _products.getAll()) {
      final expiry = _dateOnly(product.expirationDate);
      final daysRemaining = expiry.difference(date).inDays;
      if (daysRemaining < 0) {
        alerts.add(ProductAlert(
          product: product,
          type: ProductAlertType.expired,
          daysRemaining: daysRemaining,
        ));
      } else if (daysRemaining <= 30) {
        alerts.add(ProductAlert(
          product: product,
          type: ProductAlertType.expiringSoon,
          daysRemaining: daysRemaining,
        ));
      }

      if (product.quantity == 0) {
        alerts.add(ProductAlert(
          product: product,
          type: ProductAlertType.lowStock,
        ));
      }
    }

    final filtered = filter == ProductAlertFilter.all
        ? alerts
        : alerts.where((alert) => alert.filter == filter);
    return List.unmodifiable(filtered);
  }

  Future<Product> useInRoutine(String productId) async {
    final product = await _findProduct(productId);
    if (product.quantity == 0) {
      throw StateError('Product "${product.name}" is out of stock.');
    }
    return _products.update(product.copyWith(quantity: product.quantity - 1));
  }

  Future<Product> restock(String productId, {int amount = 1}) async {
    if (amount <= 0) {
      throw const FormatException('Restock amount must be greater than zero.');
    }
    final product = await _findProduct(productId);
    return _products.update(product.copyWith(quantity: product.quantity + amount));
  }

  Future<void> removeBottle(String productId) => _products.delete(productId);

  Future<Product> _findProduct(String productId) async {
    final product = await _products.getById(productId);
    if (product == null) {
      throw StateError('Product "$productId" was not found.');
    }
    return product;
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
