import 'package:e_commerceapp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
       
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return Center(child: CircularProgressIndicator()); 
        }
        if (!authController.isLoggedIn.value) {
          return Center(
            child: Text("User not logged in", style: TextStyle(fontSize: 18)),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade700,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 20),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileDetail(Icons.email, "Email", authController.userEmail.value),
                        Divider(),
                        _buildProfileDetail(Icons.person, "Username", authController.userName.value),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileDetail(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        SizedBox(width: 10),
        Text("$title:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(width: 10),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  
}