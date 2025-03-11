import 'package:e_commerceapp/view/check_outscreen.dart';
import 'package:e_commerceapp/view/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/cart_controller.dart';
import 'package:e_commerceapp/view/home_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              "Your cart is empty!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.image,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                    },
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "\$${item.price}",
                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => cartController.removeFromCart(item),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 140, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: \$${cartController.totalPrice.value.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (cartController.cartItems.isNotEmpty) {
                          Get.to(() => CheckoutScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.blue.shade700,
                      ),
                      child: Text("Checkout", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              )),
          Divider(height: 1, color: Colors.grey.shade300),
          BottomNavigationBar(
            selectedItemColor: Colors.blue.shade700,
            unselectedItemColor: Colors.grey,
            currentIndex: 1, 
            onTap: (index) {
              if (index == 0) {
                Get.to(() => HomeScreen());
              } else if (index == 2) {
                Get.to(() => OrdersScreen()); 
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"), 
            ],
          ),
        ],
      ),
    );
  }
}