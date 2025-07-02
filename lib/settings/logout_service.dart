import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class LogoutService {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<bool> logoutUser() async {
    final token = await TokenStorage.getToken();
    if (token == null || _baseUrl.isEmpty) return false;

    final response = await http.delete(
      Uri.parse('$_baseUrl/logout.php'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await TokenStorage.clearToken();
      await TokenStorage.clearCredentials();
      return true;
    } else {
      return false;
    }
  }
}
