import 'package:get/get.dart';
import 'category_service.dart';
import 'home_product_service.dart';
import 'announcement_service.dart';
class CustomerHomeController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var isLoadingCategories = true.obs;
  var isLoadingProducts = true.obs;

  var flashSale = <Map<String, dynamic>>[].obs;
  var featuredProducts = <Map<String, dynamic>>[].obs;
  var bestSales = <Map<String, dynamic>>[].obs;
  var sliders = <String>[].obs;
  var headline = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadHomeProducts();
    loadAnnouncements();
  }

  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      final data = await CategoryService.fetchCategories();
      categories.value = data;
    } catch (e) {
      print('❌ Error loading categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadHomeProducts() async {
    try {
      isLoadingProducts.value = true;
      final data = await HomeProductService.fetchHomePageProducts();
      flashSale.value = data['flash_sales']!;
      featuredProducts.value = data['featured_products']!;
      bestSales.value = data['best_sales']!;
    } catch (e) {
      print('❌ Error loading products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }


  Future<void> loadAnnouncements() async {
    try {
      final data = await AnnouncementService.fetchAnnouncements();
      sliders.value = data['sliders'].map<String>((e) => e['image_url'].toString()).toList();
      headline.value = data['headline'] ?? '';
    } catch (e) {
      print('❌ Error loading announcements: $e');
    }
  }
}
