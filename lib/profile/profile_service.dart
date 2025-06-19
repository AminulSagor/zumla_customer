import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/token_storage.dart';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:mime/mime.dart'; // for lookupMimeType
import 'package:path/path.dart'; // for basename


class ProfileService {
  static Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      final token = await TokenStorage.getToken();
      final baseUrl = dotenv.env['BASE_URL'];
      final response = await http.get(
        Uri.parse('$baseUrl/get_cus_profile.php'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );


      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        throw Exception("Failed to fetch profile");
      }
    } catch (e) {
      print("❌ Profile fetch error: $e");
      return null;
    }
  }


  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final token = await TokenStorage.getToken();
      final baseUrl = dotenv.env['BASE_URL'];

      final uri = Uri.parse('$baseUrl/upload_profile.php');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Detect MIME type
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final type = mimeType.split('/');

      // Attach image
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        imageFile.path,
        contentType: MediaType(type[0], type[1]),
        filename: basename(imageFile.path),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['profile_image']; // return URL
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("❌ Upload error: $e");
      return null;
    }
  }
}
