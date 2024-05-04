import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class HistoryController {
  Future<List<Map<String, dynamic>>> fetchHistory(String userId) async {
    try {
      var response = await http.get(Uri.parse('${ApiService.historyUrl}/$userId'));
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
            "timestamp": 0,
            "status": "Failed to load history"
          }
        ];
      }
    } catch (e) {
      return [
        {
          "recordId": 0,
          "userId": 0,
          "timestamp": 0,
          "status": "Error occurred: $e"
        }
      ];
    }
  }
}
