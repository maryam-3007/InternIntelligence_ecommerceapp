import 'package:e_commerceapp/controller/cart_controller.dart';
import 'package:e_commerceapp/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/view/splash/splash_screen.dart';

void main(){
  Get.put(ProductController());
  Get.put(CartController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}