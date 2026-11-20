import '../models/product.dart';
import '../repositories/product_repository.dart';

class InventoryBackend {
  InventoryBackend(this._products);

  final ProductRepository _products;

  Future<List<Product>> loadProducts({
    String searchQuery = '',
    ProductCategory? category,
    ProductShelfStatus? status,
    DateTime? today,
  }) async {
    final query = searchQuery.trim().toLowerCase();
    final products = await _products.getAll();

    return List.unmodifiable(products.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
      final matchesCategory = category == null || product.category == category;
      final matchesStatus =
          status == null || product.shelfStatus(today: today) == status;
      return matchesQuery && matchesCategory && matchesStatus;
    }));
  }

  Future<Map<ProductCategory, int>> categoryCounts() async {
    final counts = <ProductCategory, int>{
      for (final category in ProductCategory.values) category: 0,
    };
    for (final product in await _products.getAll()) {
      counts.update(product.category, (count) => count + 1);
    }
    return Map.unmodifiable(counts);
  }
}
