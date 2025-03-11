import 'package:e_commerceapp/view/cart_screen.dart';
import 'package:e_commerceapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/order_controller.dart';
import 'package:e_commerceapp/model/ordermodel.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderController orderController = Get.put(OrderController());
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders(); 
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Get.to(() => HomeScreen());
          break;
        case 1:
          Get.to(() => CartScreen());
          break;
        case 2:
          break; 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Cancel Selected Orders",
            onPressed: () {
              if (orderController.selectedOrders.isEmpty) {
                Get.snackbar("No Orders Selected", "Please select orders to cancel.",
                backgroundColor: Colors.red,
                colorText: Colors.white);
              } else {
                _showCancelSelectedConfirmation(context);
              }
            },
          )
        ],
      ),
      body: Obx(() {
        print("Orders Length: ${orderController.orders.length}");
        if (orderController.orders.isEmpty) {
          return Center(
            child: Text(
              "No orders placed yet!",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            OrderModel order = orderController.orders[index];
            print("Displaying Order: ${order.id}");

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: _buildLeadingIcon(order),
                title: Text(
                  "Order #${order.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${order.email}"),
                    Text(
                      "Total Price: \$${order.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    Text("Order Date: ${order.orderDate}"),
                    Text(
                      "Status: ${order.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(order.status),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade700,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(OrderModel order) {
    return Obx(() {
      if (order.status == "Cancelled") {
        return IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            orderController.deleteOrder(order.id);
          },
        );
      } else {
        return Checkbox(
          value: orderController.selectedOrders.contains(order.id),
          activeColor: Colors.blue,
          onChanged: (bool? selected) {
            orderController.toggleOrder(order.id);
          },
        );
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.grey;
      case "Completed":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  void _showCancelSelectedConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Selected Orders",style:TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
          content: const Text("Are you sure you want to cancel the selected orders?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No",style: TextStyle(color: Colors.blue),),
            ),
            TextButton(
              onPressed: () {
                orderController.cancelSelectedOrders();
                Navigator.pop(context);
              },
              child:Text("Yes, Cancel",style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );
  }
}