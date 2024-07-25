import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIS {
  String path = "http://localhost:3000";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> register(String email, String password) async {
    final url = Uri.parse('$path/register');
    final body = {'email': email, 'password': password};

    try {
      final response = await http.post(url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      bool loginResult = await login(email, password);
      return loginResult;
    } catch (e) {
      // Error occurred
      print('Error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    final url = Uri.parse('$path/login');
    final body = {'email': email, 'password': password};

    try {
      final response = await http.post(url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // Login successful
        final data = json.decode(response.body);

        prefs.setString("token", data['token']);
        prefs.setString("userId", data['userId'].toString());
        prefs.setString("userEmail", data['userEmail'].toString());

        return true;
      } else {
        // Login failed
        return false;
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
      return false;
    }
  }

  Future<dynamic> sendOTP(String email) async {
    final url = Uri.parse('$path/opt');
    final body = {'email': email};

    try {
      final response = await http.post(url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> resetPassword(String email, String opt, String newPassword,
      String confirmPassword) async {
    final url = Uri.parse('$path/resetpassword');
    final body = {
      "email": email,
      "opt": opt,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
    try {
      final response = await http.post(url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> addMessage(String receiverId, String content) async {
    final SharedPreferences prefs = await _prefs;

    final userId = prefs.getString('userId');
    final url = Uri.parse('$path/addMessage');
    final body = {
      'sendId': userId,
      'receiverId': receiverId,
      "content": content
    };

    if (content.isEmpty) {}
    try {
      final response = await http.post(url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // Login successful
        return true;
      } else {
        // Login failed
        return false;
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
      return false;
    }
  }

  Future<List<dynamic>> getChatList() async {
    final SharedPreferences prefs = await _prefs;

    final userId = prefs.getString('userId');
    final url = Uri.parse('$path/chatList?userId=$userId');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      final rowsList = <dynamic>[];
      for (var item in data['result']) {
        rowsList.add(item);
      }

      if (response.statusCode == 200) {
        return data['result'];
      } else {
        throw Exception('Failed to fetch chat list');
      }
    } catch (e) {
      print('Error: $e');

      rethrow;
    }
  }

  Future<List<dynamic>> getMessageList(String receiverId) async {
    final SharedPreferences prefs = await _prefs;

    final userId = prefs.getString('userId');
    final url =
        Uri.parse('$path/chatroom?userId=$userId&receiverId=$receiverId');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data['result'];
      } else {
        throw Exception('Failed to fetch chat list');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> chatroom(int sendId) async {
    final url = Uri.parse('$path/chatroom?receiverId=$sendId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch chat list');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<bool> verifyToken() async {
    final url = Uri.parse('$path/home');
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
