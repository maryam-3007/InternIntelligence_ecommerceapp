import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/auth_controller.dart';
import 'package:e_commerceapp/view/home_screen.dart';
import 'package:e_commerceapp/view/authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AuthController authController = Get.put(AuthController()); 

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        if (authController.isLoggedIn.value) {
          Get.off(() => HomeScreen(), transition: Transition.fadeIn);
        } else {
          Get.off(() => LoginScreen(), transition: Transition.fadeIn);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.blue.shade700),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag, size: 120, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "SwiftCart",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}