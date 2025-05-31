import 'package:get/get.dart';
import 'product_details_service.dart';

class ProductDetailsController extends GetxController {
  final String productId;

  ProductDetailsController(this.productId);

  final images = <String>[].obs;
  final reviews = <Map<String, dynamic>>[].obs;
  final colors = <String>[].obs;

  var productName = ''.obs;
  var price = ''.obs;
  var stock = ''.obs;
  var description = ''.obs;
  var storeName = ''.obs;
  var quantity = 1.obs;
  var selectedColor = ''.obs;
  var selectedImageIndex = 0.obs;
  var isLoading = false.obs;
  var brandName = ''.obs;
  var discount = ''.obs;
  var discountPrice = ''.obs;
  var model = ''.obs;
  var sellerId = ''.obs;





  final suggestedProducts = [
    {'name': 'Wireless Headset', 'image': 'assets/png/headphone.png', 'price': 100},
    {'name': 'Wireless Headset', 'image': 'assets/png/headphone.png', 'price': 100},
  ].obs;

  @override
  void onInit() {
    if (productId.isEmpty) {
      print('❌ Product ID is empty in controller. Skipping fetch.');
      return;
    }
    super.onInit();
    loadProductDetails(productId);
  }

  Future<void> loadProductDetails(String productId) async {
    try {
      print('📦 Loading product with ID: $productId');

      isLoading.value = true;
      final data = await ProductDetailsService.fetchProductDetails(productId);

      productName.value = data['product_name'] ?? '';
      price.value = data['price'] ?? '0';
      stock.value = data['stock'] ?? '0';
      description.value = data['description'] ?? '';
      storeName.value = data['brand'] ?? '';
      discount.value = data['discount'] ?? '';
      discountPrice.value = data['discount_price']?.toString() ?? price.value;

      model.value = data['model'] ?? '';
      sellerId.value = data['seller_id'] ?? '';


      // ✅ Corrected dynamic color assignment
      colors.value = List<String>.from(data['colors'] ?? []);
      selectedColor.value = colors.isNotEmpty ? colors.first : '';

      images.value = List<String>.from(data['images'] ?? []);
      selectedImageIndex.value = 0;

      reviews.value = List<Map<String, dynamic>>.from(data['reviews'] ?? []);
    } catch (e) {
      print('❌ Error loading product details for ID $productId: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
