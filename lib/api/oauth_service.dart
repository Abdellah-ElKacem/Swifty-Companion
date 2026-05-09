import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String baseUrl = "https://api.intra.42.fr/v2";
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  // Retrieve an OAuth2 Client Credentials token
  Future<String> _getAccessToken() async {
    // Use existing token if it's still valid (with a 60s buffer)
    if (_accessToken != null && 
        _tokenExpiry != null && 
        DateTime.now().isBefore(_tokenExpiry!.subtract(const Duration(seconds: 60)))) {
      return _accessToken!;
    }

    final String clientId = dotenv.env['API_UID'] ?? '';
    final String clientSecret = dotenv.env['API_SECRET'] ?? '';

    final response = await http.post(
      Uri.parse("https://api.intra.42.fr/oauth/token"),
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      // Keep track of expiration (usually 7200 seconds / 2 hours)
      final int expiresIn = data['expires_in'];
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      return _accessToken!;
    } else {
      throw Exception("Failed to authenticate with 42 Intra API");
    }
  }

  // Fetch a user's details by login
  Future<Map<String, dynamic>> fetchUserProfile(String login) async {
    final token = await _getAccessToken();
    
    final response = await http.get(
      Uri.parse("$baseUrl/users/$login"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("User '$login' not found");
    } else {
      throw Exception("Network error: Status code ${response.statusCode}");
    }
  }
}