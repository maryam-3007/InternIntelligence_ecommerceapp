import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/cart_controller.dart';
import 'package:e_commerceapp/model/model.dart';
import 'package:e_commerceapp/view/home_screen.dart';
import 'package:e_commerceapp/view/cart_screen.dart';
import 'package:e_commerceapp/view/orders_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.put(CartController());

  ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade700.withOpacity(0.8),
                      Colors.blue.shade400.withOpacity(0.6),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: product.image,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            product.image,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.green.shade300, blurRadius: 6, spreadRadius: 1)
                        ],
                      ),
                      child: Text(
                        "\$${product.price}",
                        style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shadowColor: Colors.blue.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          product.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => cartController.addToCart(product),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue.shade800,
                          elevation: 5,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(() {
      int cartCount = cartController.cartItems.length;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Adjust index if needed
          onTap: (index) {
            if (index == 0) Get.offAll(() => HomeScreen());
            if (index == 1) Get.to(() => CartScreen());
            if (index == 2) Get.to(() => OrdersScreen());
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          cartCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          ],
        ),
      );
    });
  }
}