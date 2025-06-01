import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes.dart';
import '../services/auth_service.dart';
import '../storage/token_storage.dart';

import '../utils/validators.dart';
import '../widgets/otp_dialog_widgets.dart';



class SignUpController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();


  var isLoginMode = false.obs;

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;


  var usernameError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var phoneError = RxnString();
  var addressError = RxnString();


  var isAddressTouched = false.obs;
  var isUsernameTouched = false.obs;
  var isPasswordTouched = false.obs;
  var isConfirmPasswordTouched = false.obs;
  var isPhoneTouched = false.obs;
  var isLoading = false.obs;



  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    usernameController.addListener(() {
      isUsernameTouched.value = true;
      validateForm();
    });

    passwordController.addListener(() {
      isPasswordTouched.value = true;
      validateForm();
    });

    confirmPasswordController.addListener(() {
      isConfirmPasswordTouched.value = true;
      validateForm();
    });

    phoneController.addListener(() {
      isPhoneTouched.value = true;
      validateForm();
    });

    addressController.addListener(() {
      isAddressTouched.value = true;
      validateForm();
    });
  }


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void validateForm() {
    if (!isLoginMode.value) {
      if (isUsernameTouched.value) {
        usernameError.value = Validators.validateUsername(usernameController.text);
      }

      if (isConfirmPasswordTouched.value) {
        confirmPasswordError.value = Validators.validateConfirmPassword(
          passwordController.text,
          confirmPasswordController.text,
        );
      }
    }

    if (!isLoginMode.value) {
      if (isAddressTouched.value) {
        addressError.value = addressController.text.trim().isEmpty ? "Address is required" : null;
      }
    }
    final addressValid = isLoginMode.value || addressController.text.trim().isNotEmpty;


    if (isPasswordTouched.value) {
      passwordError.value = Validators.validatePassword(passwordController.text);
    }

    if (isPhoneTouched.value) {
      phoneError.value = Validators.validatePhone(phoneController.text);
    }

    // isFormValid should always be checked regardless of touch
    final usernameValid = isLoginMode.value || Validators.validateUsername(usernameController.text) == null;
    final confirmPasswordValid = isLoginMode.value || Validators.validateConfirmPassword(
      passwordController.text,
      confirmPasswordController.text,
    ) == null;
    final passwordValid = Validators.validatePassword(passwordController.text) == null;
    final phoneValid = Validators.validatePhone(phoneController.text) == null;

    isFormValid.value = usernameValid && confirmPasswordValid && passwordValid && phoneValid  && addressValid;
  }


  Future<void> handleNext(BuildContext context) async {
    final name = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final address = addressController.text.trim();

    try {
      final res = await AuthService().registerCustomer(
        name: name,
        phone: phone,
        password: password,
        address: address,
      );

      if (res['status'] == 'success') {
        Get.snackbar("Success", res['message'] ?? "Registration successful",
            backgroundColor: Colors.green, colorText: Colors.white);
        //Get.offAllNamed(AppRoutes.login); // or wherever you want to redirect
      } else {
        Get.snackbar("Error", res['message'] ?? "Registration failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  Future<void> handleLogin() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await AuthService().loginSeller(phone: phone, password: password);

      if (res['status'] == 'success') {
        final token = res['user']['token'];
        final phone = res['user']['phone'];

        await TokenStorage.saveToken(token);
        await TokenStorage.savePhoneNumber(phone);

        // Navigate to home or dashboard
        // Example:
        Get.offAllNamed(AppRoutes.homePage);
      } else {
        Get.snackbar("Login Failed", res['message'] ?? "Unknown error",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }



  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.onClose();
  }
}
