import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class UserManagementController {
  Future<String> registerUser(String username, String password, String email) async {
    try {
      var response = await http.post(
        Uri.parse(ApiService.registerUrl),
        body: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      if (response.statusCode == 200) {
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
        body: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return "Login successful";
      } else {
        return "Invalid credentials";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }
}
