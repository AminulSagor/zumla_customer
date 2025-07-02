// lib/customer_home/announcement_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AnnouncementService {
  static const String _baseUrl = 'https://jumlaonline.com/api/get_announcements.php';

  static Future<Map<String, dynamic>> fetchAnnouncements() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'success') {
        return {
          'sliders': List<Map<String, dynamic>>.from(body['sliders']),
          'headline': body['headline']?['header'] ?? '',
        };
      }
    }

    return {
      'sliders': [],
      'headline': '',
    };
  }
}
