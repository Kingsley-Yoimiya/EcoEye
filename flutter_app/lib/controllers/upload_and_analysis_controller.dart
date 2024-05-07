import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UploadAndAnalysisController {
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<String> uploadPhoto(Uint8List photoBytes, String filename) async {
    try {
      String token = await _getToken();
      String userId = await _getUserId();
      
      var request = http.MultipartRequest('POST', Uri.parse(ApiService.uploadUrl));
      request.headers['Authorization'] = 'Token $token';
      request.fields['userId'] = userId;
      request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: filename));
      
      var response = await request.send();
      if (response.statusCode == 200) {
        return "File uploaded successfully";
      } else {
        var responseBody = await response.stream.bytesToString();
        return "Failed to upload file: $responseBody";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  Future<String> analyzePhoto(Uint8List photoBytes, String filename) async {
    try {
      String token = await _getToken();
      String userId = await _getUserId();
      
      var request = http.MultipartRequest('POST', Uri.parse(ApiService.analyzeUrl));
      request.headers['Authorization'] = 'Token $token';
      request.fields['userId'] = userId;
      request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: filename));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return response.body; // 可能需要解析JSON
      } else {
        return "Failed to analyze photo";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }
}
