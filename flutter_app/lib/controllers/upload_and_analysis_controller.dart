import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'dart:io';

class UploadAndAnalysisController {
  Future<String> uploadPhoto(File photo) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiService.uploadUrl))
        ..files.add(await http.MultipartFile.fromPath('photo', photo.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        return "File uploaded successfully";
      } else {
        return "Failed to upload file";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }

  Future<String> analyzePhoto(File photo) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiService.analyzeUrl))
        ..files.add(await http.MultipartFile.fromPath('photo', photo.path));
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
