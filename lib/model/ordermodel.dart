import 'dart:convert';

class OrderModel {
  final int id;
  final String email;
  final List<Map<String, dynamic>> products;
  final double totalPrice;
  final String orderDate;
  final String status;

  OrderModel({
    required this.id,
    required this.email,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });

  OrderModel copyWith({
    int? id,
    String? email,
    List<Map<String, dynamic>>? products,
    double? totalPrice,
    String? orderDate,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      email: email ?? this.email,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
    );
  }

 factory OrderModel.fromJson(Map<String, dynamic> json) {
  return OrderModel(
    id: json['id'],
    email: json['email'],
    products: json['products'] is String
        ? List<Map<String, dynamic>>.from(
          jsonDecode(json['products']).map((item) => Map<String, dynamic>.from(item))
          )
        : List<Map<String, dynamic>>.from(json['products']),
    totalPrice: (json['totalPrice'] as num).toDouble(), 
    orderDate: json['orderDate'],
    status: json['status'],
  );
}
}