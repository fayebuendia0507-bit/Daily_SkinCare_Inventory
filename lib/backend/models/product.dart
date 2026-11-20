enum ProductCategory {
  cleanser('Cleanser'),
  toner('Toner'),
  serum('Serum'),
  moisturizer('Moisturizer'),
  sunscreen('Sunscreen'),
  others('Others');

  const ProductCategory(this.label);

  final String label;
}

enum ProductShelfStatus {
  good,
  expiringSoon,
  expired,
  lowStock,
}

class Product {
  const Product({
    required this.id,
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

  final String id;
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

  ProductShelfStatus shelfStatus({DateTime? today}) {
    final date = _dateOnly(today ?? DateTime.now());
    final expiry = _dateOnly(expirationDate);

    if (expiry.isBefore(date)) return ProductShelfStatus.expired;
    if (!expiry.isAfter(date.add(const Duration(days: 30)))) {
      return ProductShelfStatus.expiringSoon;
    }
    if (quantity == 0) return ProductShelfStatus.lowStock;
    return ProductShelfStatus.good;
  }

  double get freshnessProgress {
    if (openedAt == null || paoMonths == null || paoMonths! <= 0) return 1;
    final totalDays = paoMonths! * 30.4375;
    final elapsedDays = DateTime.now().difference(openedAt!).inHours / 24;
    return (1 - elapsedDays / totalDays).clamp(0, 1).toDouble();
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    ProductCategory? category,
    int? quantity,
    double? price,
    DateTime? expirationDate,
    DateTime? openedAt,
    bool clearOpenedAt = false,
    int? paoMonths,
    bool clearPaoMonths = false,
    String? notes,
    List<String>? routineTags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      expirationDate: expirationDate ?? this.expirationDate,
      openedAt: clearOpenedAt ? null : openedAt ?? this.openedAt,
      paoMonths: clearPaoMonths ? null : paoMonths ?? this.paoMonths,
      notes: notes ?? this.notes,
      routineTags: routineTags ?? this.routineTags,
    );
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
