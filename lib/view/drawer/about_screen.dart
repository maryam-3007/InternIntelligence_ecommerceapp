import 'package:e_commerceapp/view/authentication/login_screen.dart';
import 'package:e_commerceapp/view/drawer/profile_screen.dart';
import 'package:e_commerceapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      drawer: _buildDrawer(context),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.shopping_bag, size: 50, color: Colors.blue.shade700),
            ),
            SizedBox(height: 10),
            Text(
              "SwiftCart",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
            ),
            SizedBox(height: 5),
            Text(
              "Bringing You the Best Shopping Experience!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFeatureTile(Icons.shopping_cart, "Wide Product Range", "From fashion to gadgets, we have everything you need."),
                    _buildFeatureTile(Icons.local_shipping, "Fast & Reliable Delivery", "Get your orders delivered quickly and securely."),
                    _buildFeatureTile(Icons.security, "Secure Shopping", "Your data and payments are always safe with us."),
                    _buildFeatureTile(Icons.thumb_up, "Customer Satisfaction", "We value your trust and provide top-quality products."),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            Text(
              "Get in Touch",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
            ),
            SizedBox(height: 10),
            _buildContactRow(Icons.email, "support@swiftcart.com"),
            _buildContactRow(Icons.phone, "+123 456 7890"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
                ),
                SizedBox(height: 10),
                Text("Hello, Shopper!", style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text("Home"),
            onTap: () => Get.offAll(() => HomeScreen()),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text("About"),
            onTap: () {
              Get.back(); 
              Get.to(() => AboutScreen()); 
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text("Profile"),
            onTap: () {
              Get.to(()=>ProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.blue),
            title: Text("Logout"),
            onTap: () {
              Get.offAll(()=>LoginScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700, size: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}