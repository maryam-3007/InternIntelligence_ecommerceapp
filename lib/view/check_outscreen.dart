import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/cart_controller.dart';
import 'package:e_commerceapp/controller/order_controller.dart';
import 'package:e_commerceapp/view/home_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.put(OrderController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(nameController, "Full Name", Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(addressController, "Address", Icons.location_on),
                      const SizedBox(height: 15),
                      _buildTextField(phoneController, "Phone Number", Icons.phone, isNumber: true),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              Obx(() => Center(
                child: Text(
                  "Total Price: \$${cartController.totalPrice.value.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                ),
              )),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _placeOrder,
                  icon: const Icon(Icons.shopping_cart_checkout, size: 24,color: Colors.white,),
                  label: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (nameController.text.isEmpty || addressController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar(
        "Error", "Please fill all details",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    await orderController.placeOrder(
      nameController.text,
      cartController.cartItems.map((product) => {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "quantity": 1,
      }).toList(),
      cartController.totalPrice.value,
    );

    cartController.clearCart();
    Get.snackbar("Success", "Order Placed Successfully",
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM
    );
    Get.offAll(() => HomeScreen());
  }
}