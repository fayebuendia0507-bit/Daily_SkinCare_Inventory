import 'product.dart';

enum ProductAlertType {
  expiringSoon,
  expired,
  lowStock,
}

enum ProductAlertFilter {
  all,
  expiringSoon,
  expired,
  lowStock,
}

class ProductAlert {
  const ProductAlert({
    required this.product,
    required this.type,
    this.daysRemaining,
  });

  final Product product;
  final ProductAlertType type;
  final int? daysRemaining;

  ProductAlertFilter get filter => switch (type) {
        ProductAlertType.expiringSoon => ProductAlertFilter.expiringSoon,
        ProductAlertType.expired => ProductAlertFilter.expired,
        ProductAlertType.lowStock => ProductAlertFilter.lowStock,
      };
}
