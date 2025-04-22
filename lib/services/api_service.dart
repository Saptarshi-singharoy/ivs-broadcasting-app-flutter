import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Replace with your Node.js server URL
  static const String _baseUrl = 'http://192.168.1.2:3000';

  // Method to create a channel
  static Future<Map<String, dynamic>> createChannel(bool isPrivate) async {
    try {
      final url = Uri.parse('$_baseUrl/channel/create-channel');
      print("RESPONSE VALUE BEFORE");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'isPrivate': isPrivate,
        }),
      );

      print("RESPONSE VALUE ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to create channel');
      }
    } catch (e) {
      print("Error while creating channel");
      print(e);
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<Map<String, dynamic>> findChannel() async {
    try {
      final url = Uri.parse('$_baseUrl/channel/find-channel');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'channelName': "Saptarshi-c40a2f3d-a810-438d-ab47-69f309539c27",
          'userId': "123"
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception("Failed to fetch stream");
      }
    } catch (e) {
      print("Error while fetching channel");
      print(e);
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<void> sendNotifications(dynamic title, dynamic body) async {
    try {
      final fetchTokensUrl = Uri.parse('$_baseUrl/token/send-notification');

      final response = await http.post(fetchTokensUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'title': title, 'body': body}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception("Failed to fetch stream");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> saveToken(
      dynamic fcmToken, String userId) async {
    try {
      print("SAVE TOKEN API CALLED FROM MOBILE");
      final url = Uri.parse('$_baseUrl/token/save-token');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': fcmToken, 'userId': userId}),
      );

      print("TOKEN RESPONSE");
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception("Failed to save token");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
