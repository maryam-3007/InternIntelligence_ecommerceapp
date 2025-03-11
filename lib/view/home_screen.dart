import 'package:e_commerceapp/controller/auth_controller.dart';
import 'package:e_commerceapp/view/drawer/about_screen.dart';
import 'package:e_commerceapp/view/cart_screen.dart';
import 'package:e_commerceapp/view/authentication/login_screen.dart';
import 'package:e_commerceapp/view/orders_screen.dart';
import 'package:e_commerceapp/view/product_detailsscreen.dart';
import 'package:e_commerceapp/view/drawer/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerceapp/controller/product_controller.dart';
import 'package:e_commerceapp/controller/cart_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryBar(),
          Expanded(child: _buildProductList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () => Get.offAll(() => HomeScreen())),
          _buildDrawerItem(Icons.person, 'Profile', () => Get.to(() => ProfileScreen())),
          _buildDrawerItem(Icons.info, 'About', () => Get.to(() => AboutScreen())),
          _buildDrawerItem(Icons.logout, 'Logout', () async {
            await AuthController().logoutUser();
            Get.offAll(()=>LoginScreen());
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6)],
        ),
        child: TextField(
          onChanged: (query) => productController.searchProduct(query),
          decoration: InputDecoration(
            hintText: "Search products...",
            prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: productController.categories.map((category) {
            bool isSelected = productController.selectedCategory.value == category;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => productController.filterByCategory(category),
                selectedColor: Colors.blue.shade700,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

 Widget _buildProductList() {
  return Obx(() {
    if (productController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: productController.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productController.filteredProducts[index];
                return GestureDetector(
                  onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "\$${product.price}",
                            style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              cartController.addToCart(product);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ), 
                              
                            ),                          
                            child: Row(
                              children: [
                                Icon(Icons.shopping_cart_checkout,color: Colors.white,),
                                Text("Add to Cart", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (productController.isMoreLoading.value)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.blue.shade700,),
            ),
          if (!productController.isMoreLoading.value)
            ElevatedButton(
              onPressed: () {
                productController.fetchProducts(isLoadMore: true);
              },
              child: const Text("Load More",style: TextStyle(color:Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700
              ),
            ),
        ],
      ),
    );
  });
}

  Widget _buildBottomNavBar() {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
                if (cartController.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartController.cartItems.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
        ],
      );
    });
  }
}