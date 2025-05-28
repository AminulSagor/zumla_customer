import 'package:get/get.dart';

class SearchViewController extends GetxController {
  final searchText = ''.obs;

  void onSearchChanged(String value) {
    searchText.value = value;
    // Optionally: perform search logic here
  }

  void onFilterTap() {
    // Optionally: show filter modal or navigation
  }
}
