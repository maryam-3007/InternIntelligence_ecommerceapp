import 'package:e_commerceapp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  void register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty || phoneNumber.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    bool success = await authController.registerUser(email, password, username);

    if (success) {
      Get.snackbar("Success", "Account created successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Future.delayed(const Duration(seconds: 2), () {
        Get.off(() => LoginScreen());
      });
    } else {
      Get.snackbar("Error", "Email already exists!",
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
                child: Icon(Icons.person_add, size: 50, color: Colors.white),
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
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Fill in the details to get started",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(usernameController, "Username", Icons.person),
                    const SizedBox(height: 15),

                    _buildTextField(emailController, "Email", Icons.email),
                    const SizedBox(height: 15),

                    _buildTextField(phoneNumberController, "Phone Number", Icons.phone),
                    const SizedBox(height: 15),

                    _buildTextField(passwordController, "Password", Icons.lock,
                    ),
                    
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: TextButton(
                        onPressed: () => Get.to(() => LoginScreen()),
                        child: const Text(
                          "Already have an account? Login",
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
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