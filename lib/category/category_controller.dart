import 'package:get/get.dart';
import 'category_service.dart';

class CategoryController extends GetxController {
  final categories = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    try {
      final data = await CategoryService.fetchCategories();
      categories.value = data;
    } catch (e) {
      print('Error loading categories: $e');
    }
  }
}