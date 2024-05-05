import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagementController {
  Future<String> registerUser(String username, String password, String email) async {
    try {
      var response = await http.post(
        Uri.parse(ApiService.registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );
      if (response.statusCode == 201) {
        return "User created successfully";
      } else {
        return "Failed to register user";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  Future<String> loginUser(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse(ApiService.loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // 解析响应体中的数据
        var data = json.decode(response.body);
        // 假设服务器返回的响应体中包含用户名、用户 ID 和 token
        String userId = data['userId'].toString();
        String token = data['token'];

        // 使用 SharedPreferences 保存用户名、用户 ID 和 token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', userId);
        await prefs.setString('username', username);
        await prefs.setString('token', token);
        
        return "Login successful";
      } else {
        return "Invalid credentials";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('token');
    // 根据需要移除其他保存的信息
  }

  // 根据需要添加其他方法，如检查用户是否已登录
}
