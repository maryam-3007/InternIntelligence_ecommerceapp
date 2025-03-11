import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs; 
  var userEmail = ''.obs; 
  var userName = ''.obs; 
  var isLoading = false.obs;

  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool("isLoggedIn") ?? false;
    userEmail.value = prefs.getString("userEmail") ?? "";
    userName.value = prefs.getString("userName") ?? "";
  }

 
  Future<bool> registerUser(String email, String password, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

   
    String? existingUser = prefs.getString("userEmail");
    if (existingUser != null) {
      return false; 
    }

    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));

    await prefs.setString("userEmail", email);
    await prefs.setString("userPassword", password);
    await prefs.setString("userName", name);
    isLoading.value = false;
    return true; 
  }

  
  Future<bool> loginUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedEmail = prefs.getString("userEmail");
    String? storedPassword = prefs.getString("userPassword");

    isLoading.value = true; 
    await Future.delayed(Duration(seconds: 2)); 

    if (storedEmail == email && storedPassword == password) {
      await prefs.setBool("isLoggedIn", true);
      isLoggedIn.value = true;
      userEmail.value = email;
      userName.value = prefs.getString("userName") ?? "";
      isLoading.value = false; 
      return true; 
    }

    isLoading.value = false;
    return false; 
  }

  Map<String, String> getUserDetails() {
    return {
      "email": userEmail.value,
      "name": userName.value,
    };
  }

  
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    isLoggedIn.value = false;
    userEmail.value = "";
    userName.value = "";
  }
}