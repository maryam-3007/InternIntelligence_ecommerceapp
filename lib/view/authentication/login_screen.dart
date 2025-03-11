import 'package:e_commerceapp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter both email and password",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    bool isSuccess = await authController.loginUser(email, password);
    if (isSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("email", email);

      Get.off(() => HomeScreen());
    } else {
      Get.snackbar("Error", "Invalid credentials",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue.shade700,
                child: Icon(Icons.shopping_bag, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Sign in to continue",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(emailController, "Email", Icons.email),
                    const SizedBox(height: 15),
                    Obx(() => _buildTextField(
                          passwordController,
                          "Password",
                          Icons.lock,
                          obscureText: obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                              color: Colors.blue.shade700,
                            ),
                            onPressed: () => obscurePassword.value = !obscurePassword.value,
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() {
                      return authController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            );
                    }),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.to(() => RegisterScreen()),
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
    );
  }
}