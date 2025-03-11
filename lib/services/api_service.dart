import 'package:get/get.dart';

class ApiService extends GetConnect {
  Future<Response> getProducts({int limit = 30, int skip = 0}) async {
    return await get('https://dummyjson.com/products?limit=$limit&skip=$skip');
  }
}