import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  Future<Map<String, dynamic>> uploadPhoto(Uint8List photoBytes, String filename) async {
    try {
      String token = await _getToken();
      String userId = await _getUserId();
      
      var request = http.MultipartRequest('POST', Uri.parse(ApiService.uploadUrl));
      request.headers['Authorization'] = 'Token $token';
      request.fields['userId'] = userId;
      request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: filename));
      
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var parsedBody = json.decode(responseBody);
        return {
          "status": "File uploaded successfully",
          "message": parsedBody["message"],
          "recordId": parsedBody["recordId"]
        };
      } else {
        var responseBody = await response.stream.bytesToString();
        return {
          "status": "Failed to upload file",
          "message": responseBody,
          "recordId": null
        };
      }
    } catch (e) {
      return {
        "status": "Error occurred",
        "message": "$e",
        "recordId": null
      };
    }
  }

  Future<Map<String, dynamic>> analyzePhoto(Uint8List photoBytes, String filename) async {
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
        var parsedBody = json.decode(response.body);
        return {
          "status": "Analysis successful",
          "message": parsedBody["message"],
          "analysisResults": parsedBody["analysis_results"]
        };
      } else {
        return {
          "status": "Failed to analyze photo",
          "message": response.body,
          "analysisResults": null
        };
      }
    } catch (e) {
      return {
        "status": "Error occurred",
        "message": "$e",
        "analysisResults": null
      };
    }
  }
}
