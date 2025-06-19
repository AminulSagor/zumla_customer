import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_settings_controller.dart';

class AccountSettingsView extends StatelessWidget {
  final controller = Get.put(AccountSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Image.asset('assets/png/arrow_back.png', width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTile(controller.name.value),
            _buildTile("Set Password"),
            _buildTile(controller.phone.value),
            _buildTile(controller.email.value),
            _buildTile("Location"),
          ],
        );
      }),
    );
  }

  Widget _buildTile(String text) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4).copyWith(right: 24),
          title: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          tileColor: Colors.white,
          onTap: () {},
        ),
        const Divider(height: 1),
      ],
    );
  }

}
