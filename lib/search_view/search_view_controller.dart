import 'package:get/get.dart';
import 'search_service.dart';

class SearchViewController extends GetxController {
  final searchText = ''.obs;
  final brands = <String>[].obs;
  final products = [].obs;
  final isLoading = false.obs;
  final selectedBrand = RxnString(); // allows null



  @override
  void onInit() {
    super.onInit();
    final categoryId = Get.arguments?['category_id'];
    final subCategoryId = Get.arguments?['sub_category_id'];
    if (subCategoryId != null) {
      loadProductsBySubCategory(subCategoryId);
    } else if (categoryId != null) {
      loadProductsByCategory(categoryId);
    }

  }

  Future<void> loadProductsBySubCategory(String subCategoryId) async {
    try {
      isLoading.value = true;
      final results = await SearchService.getProductsBySubCategory(subCategoryId);
      products.value = results;
      extractBrands(results);
    } catch (e) {
      print('❌ Error loading subcategory products: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loadProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;
      final results = await SearchService.getProductsByCategory(categoryId);
      products.value = results;
      extractBrands(results);
    } catch (e) {
      print('❌ Error loading products by category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List get filteredProducts {
    if (selectedBrand.value == null) return products;
    return products.where((p) => p['brand'] == selectedBrand.value).toList();
  }



  void onSearchChanged(String value) async {
    searchText.value = value;

    isLoading.value = true; // Start loading
    try {
      final url = 'https://jumlaonline.com/api/search_by_keyword.php?keyword=$value';
      print('🔍 Request URL: $url');

      final results = await SearchService.searchByKeyword(value);
      print('📦 Response: $results');

      products.value = results;
      extractBrands(results);
    } catch (e) {
      print('❌ Error while searching: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }


  void extractBrands(List<dynamic> items) {
    final brandSet = items.map((e) => e['brand']).toSet();
    brands.value = brandSet.whereType<String>().toList();
  }

  void onFilterTap() {
    // open filter modal or navigate
  }
}