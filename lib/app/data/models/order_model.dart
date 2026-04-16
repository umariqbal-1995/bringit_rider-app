import 'dart:math';

class OrderModel {
  final String id;
  final String orderNumber;
  final String storeName;
  final String storeAddress;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> items;
  final double earning;
  final double distance;
  final int estimatedMinutes;
  final String status;
  final DateTime createdAt;
  final double? storeLat;
  final double? storeLng;
  final double? customerLat;
  final double? customerLng;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.storeName,
    required this.storeAddress,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.items,
    required this.earning,
    required this.distance,
    required this.estimatedMinutes,
    required this.status,
    required this.createdAt,
    this.storeLat,
    this.storeLng,
    this.customerLat,
    this.customerLng,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>? ?? {};
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final customer = json['customer'] as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['id'] != null
          ? '#${(json['id'] as String).substring((json['id'] as String).length - 6).toUpperCase()}'
          : '#ORDER',
      storeName: store['name'] as String? ?? '',
      storeAddress: store['city'] as String? ?? '',
      customerName: customer['name'] as String? ?? '',
      customerAddress: address['street'] as String? ?? '',
      customerPhone: customer['phone'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      earning: double.tryParse(json['deliveryFeePkr']?.toString() ?? '0') ?? 0.0,
      distance: _computeDistance(
        double.tryParse(store['latitude']?.toString() ?? ''),
        double.tryParse(store['longitude']?.toString() ?? ''),
        double.tryParse(address['latitude']?.toString() ?? ''),
        double.tryParse(address['longitude']?.toString() ?? ''),
      ),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'PLACED',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      storeLat: double.tryParse(store['latitude']?.toString() ?? ''),
      storeLng: double.tryParse(store['longitude']?.toString() ?? ''),
      customerLat: double.tryParse(address['latitude']?.toString() ?? ''),
      customerLng: double.tryParse(address['longitude']?.toString() ?? ''),
    );
  }

  static double _computeDistance(
      double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0.0;
    const R = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final menuItem = json['menuItem'] as Map<String, dynamic>?;
    final storeProduct = json['storeProduct'] as Map<String, dynamic>?;
    final product = storeProduct?['product'] as Map<String, dynamic>?;
    final name = menuItem?['name'] as String? ??
        product?['name'] as String? ??
        '';
    return OrderItem(
      name: name,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: double.tryParse(json['unitPricePkr']?.toString() ?? '0') ?? 0.0,
    );
  }

  double get total => price * quantity;
}
