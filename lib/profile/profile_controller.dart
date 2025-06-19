import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_service.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var phone = ''.obs;
  var imageUrl = ''.obs;

  var isLoading = true.obs;
  var isUploading = false.obs;


  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    final data = await ProfileService.fetchProfile();
    if (data != null) {
      name.value = data['name'] ?? '';
      phone.value = data['phone'] ?? '';
      imageUrl.value = data['pro_path'] ?? '';
    }
    isLoading.value = false;
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      isUploading.value = true;

      final file = File(picked.path);
      final url = await ProfileService.uploadProfileImage(file);

      if (url != null) {
        imageUrl.value = url;
      }

      isUploading.value = false;
    }
  }

}
