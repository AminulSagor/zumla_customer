import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signup/signup_view.dart';
import 'logout_service.dart';

class SettingsController extends GetxController {
  var isAccountExpanded = false.obs;
  var isCountryExpanded = false.obs;
  var isLanguageExpanded = false.obs;

  void toggleAccount() => isAccountExpanded.toggle();
  void toggleCountry() => isCountryExpanded.toggle();
  void toggleLanguage() => isLanguageExpanded.toggle();

  Future<void> logout() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await LogoutService.logoutUser();
    Get.back(); // Close the loading dialog

    if (success) {
      Get.offAll(() => SignUpView()); // Navigate to login screen
      Get.snackbar("Success", "Logout Successful");
    } else {
      Get.snackbar("Error", "Logout failed. Please try again.");
    }
  }
}
