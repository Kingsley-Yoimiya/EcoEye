import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // 引入 intl 包

class HistoryController {
  Future<List<Map<String, dynamic>>> fetchHistory(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Ensure the URL includes userId
      var response = await http.get(
        Uri.parse('${ApiService.historyUrl}/$userId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      print("Response status: ${response.statusCode}");
      //print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Map<String, dynamic>> parsedData = jsonData.map((data) {
          return {
            "recordId": data["recordId"],
            "userId": data["userId"],
            "timestamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.parse(data["timestamp"])
                    .toUtc()
                    .add(Duration(hours: 8))),
            "status": "Success"
          };
        }).toList();
        parsedData.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));
        return parsedData;
      } else {
        return [
          {
            "recordId": 0,
            "userId": 0,
            "timestamp": response.statusCode,
            "status": "Failed to load history: ${response.body}"
          }
        ];
      }
    } catch (e) {
      return [
        {
          "recordId": 114,
          "userId": 0,
          "timestamp": 0,
          "status": "Error occurred: $e"
        }
      ];
    }
  }

  // 在 HistoryController 类中添加以下方法
  Future<Map<String, dynamic>> fetchRecordDetail(int recordId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('${ApiService.resultUrl}/$recordId/'), // 确保这是获取单个记录详情的正确URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return {
          "recordId": jsonData["recordId"],
          "photo": jsonData["photo"], // 假设响应中包含照片的URL
          "analysisResults": jsonData["analysisResults"],
          "timestamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(
              DateTime.parse(jsonData["timestamp"])
                  .toUtc()
                  .add(Duration(hours: 8))),
          "status": "Success"
        };
      } else {
        return {"status": "Failed to load record detail: ${response.body}"};
      }
    } catch (e) {
      return {"status": "Error occurred: $e"};
    }
  }
}
