import 'dart:convert';
import 'package:get/get.dart';
import 'package:e_commerceapp/services/db_helper.dart';
import 'package:e_commerceapp/model/ordermodel.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var selectedOrders = <int>[].obs;
  final DBHelper dbHelper = DBHelper();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  void fetchOrders() async {
    var db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.query("orders");

    print("Fetched orders from DB: $result"); 
    orders.clear();
    orders.addAll(result.map((order) => OrderModel.fromJson(order)).toList());

    print("Updated orders list: ${orders.length} items");
  }

  Future<void> placeOrder(String email, List<Map<String, dynamic>> products, double totalPrice) async {
    var db = await dbHelper.database;
    int orderId = await db.insert("orders", {
      "email": email,
      "products": jsonEncode(products),
      "totalPrice": totalPrice,
      "orderDate": DateTime.now().toString(),
      "status": "Pending",
    });

    orders.add(OrderModel(
      id: orderId,
      email: email,
      products: products,
      totalPrice: totalPrice,
      orderDate: DateTime.now().toString(),
      status: "Pending",
    ));
  }

  void toggleOrder(int orderId) {
    if (selectedOrders.contains(orderId)) {
      selectedOrders.remove(orderId);
    } else {
      selectedOrders.add(orderId);
    }
  }

  void cancelSelectedOrders() async {
    var db = await dbHelper.database;
    for (int orderId in selectedOrders) {
      await db.update(
        "orders",
        {"status": "Cancelled"},
        where: "id = ?",
        whereArgs: [orderId],
      );
      int index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: "Cancelled");
      }
    }
    selectedOrders.clear();
  }

  void deleteOrder(int orderId) async {
    var db = await dbHelper.database;
    await db.delete("orders", where: "id = ?", whereArgs: [orderId]);
    orders.removeWhere((order) => order.id == orderId);
  }
}