import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isAccountExpanded = false.obs;
  var isCountryExpanded = false.obs;
  var isLanguageExpanded = false.obs;

  void toggleAccount() => isAccountExpanded.toggle();
  void toggleCountry() => isCountryExpanded.toggle();
  void toggleLanguage() => isLanguageExpanded.toggle();

  void logout() {
    // Add your logout logic here
    print("Logging out...");
  }
}
