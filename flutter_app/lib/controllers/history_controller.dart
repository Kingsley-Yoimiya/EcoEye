import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            "timestamp": data["timestamp"],
            "status": "Success"
          };
        }).toList();
        parsedData.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));
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
}
