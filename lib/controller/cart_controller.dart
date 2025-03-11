import 'package:get/get.dart';
import 'package:e_commerceapp/model/model.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  var totalPrice = 0.0.obs;

  void addToCart(Product product) {
    cartItems.add(product);
    totalPrice.value += product.price;
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    totalPrice.value -= product.price;
  }

  void clearCart() {
    cartItems.clear();
    totalPrice.value = 0.0;
  }
}