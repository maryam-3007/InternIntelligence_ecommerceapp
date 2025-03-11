import 'package:get/get.dart';
import 'package:e_commerceapp/model/model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var isMoreLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var page = 0.obs;
  final int limit = 20; 

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isMoreLoading(true);
        page.value += limit; 
      } else {
        isLoading(true);
        page.value = 0; 
        products.clear();
        filteredProducts.clear();
      }

      var response = await ApiService().getProducts(limit: limit, skip: page.value);
      if (response.status.isOk) {
        var productList = (response.body['products'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        
        products.addAll(productList);
        filteredProducts.assignAll(products);

        var categorySet = products.map((p) => p.category).toSet().toList();
        categories.assignAll(categorySet);
      }
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filteredProducts.assignAll(
      products.where((p) => p.category == category).toList(),
    );
  }
}