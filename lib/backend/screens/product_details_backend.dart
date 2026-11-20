import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductDetailsBackend {
  ProductDetailsBackend(this._products);

  final ProductRepository _products;

  Future<Product> load(String productId) async {
    final product = await _products.getById(productId);
    if (product == null) {
      throw StateError('Product "$productId" was not found.');
    }
    return product;
  }

  Future<void> delete(String productId) => _products.delete(productId);
}
