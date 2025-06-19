import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../account_settings/account_settings_view.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingTile('Account Settings', () => Get.to(() => AccountSettingsView())),
            _settingTile('Bangladesh', controller.toggleCountry),
            _settingTile('English', controller.toggleLanguage),
            const SizedBox(height: 8),
            const Text("Need Help?", style: TextStyle(fontSize: 16)),
            //const Spacer(),
            SizedBox(height: 40.h,),
            Center(
              child: TextButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout),
                label: const Text("Log Out", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(String title, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                const Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
