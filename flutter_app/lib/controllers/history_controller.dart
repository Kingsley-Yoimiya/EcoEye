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

      var response = await http.get(
        Uri.parse('${ApiService.historyUrl}/$userId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      // 打印原始响应内容
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // 将响应的body转换为UTF-8编码
        var utf8Body = utf8.decode(response.bodyBytes);

        // 打印UTF-8编码后的内容
        print('UTF-8 decoded body: $utf8Body');

        List<dynamic> jsonData = json.decode(utf8Body);
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
        print('Failed to load history: ${response.body}');
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
      print('Error occurred: $e');
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

  Future<Map<String, dynamic>> fetchRecordDetail(int recordId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('${ApiService.resultUrl}/$recordId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      // 打印原始响应内容
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // 将响应的body转换为UTF-8编码
        var utf8Body = utf8.decode(response.bodyBytes);

        // 打印UTF-8编码后的内容
        print('UTF-8 decoded body: $utf8Body');

        Map<String, dynamic> jsonData = json.decode(utf8Body);

        // 打印解析后的JSON数据
        print('JSON Data: $jsonData');

        return {
          "recordId": jsonData["recordId"],
          "photo": jsonData["photo"],
          "analysisResults": jsonData["analysisResults"],
          "timestamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(
              DateTime.parse(jsonData["timestamp"])
                  .toUtc()
                  .add(Duration(hours: 8))),
          "status": "Success"
        };
      } else {
        print('Failed to load record detail: ${response.body}');
        return {"status": "Failed to load record detail: ${response.body}"};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {"status": "Error occurred: $e"};
    }
  }

  Future<String> deleteRecord(int recordId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.delete(
        Uri.parse('${ApiService.deleteUrl}/$recordId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      // 打印原始响应内容
      print('Raw response body: ${response.body}');

      if (response.statusCode == 204) {
        return "Record deleted successfully";
      } else {
        print('Failed to delete record: ${response.body}');
        return "Failed to delete record: ${response.body}";
      }
    } catch (e) {
      print('Error occurred: $e');
      return "Error occurred: $e";
    }
  }

  Future<Map<String, dynamic>> reanalyzeRecord(int recordId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.put(
        Uri.parse('${ApiService.reanalyzeUrl}/$recordId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      // 打印原始响应内容
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // 将响应的body转换为UTF-8编码
        var utf8Body = utf8.decode(response.bodyBytes);

        // 打印UTF-8编码后的内容
        print('UTF-8 decoded body: $utf8Body');

        Map<String, dynamic> jsonData = json.decode(utf8Body);

        // 打印解析后的JSON数据
        print('JSON Data: $jsonData');

        return {
          "recordId": jsonData["recordId"],
          "photo": jsonData["photo"],
          "analysisResults": jsonData["analysisResults"],
          "timestamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(
              DateTime.parse(jsonData["timestamp"])
                  .toUtc()
                  .add(Duration(hours: 8))),
          "status": "Success"
        };
      } else {
        print('Failed to reanalyze record: ${response.body}');
        return {"status": "Failed to reanalyze record: ${response.body}"};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {"status": "Error occurred: $e"};
    }
  }

  Future<Map<String, dynamic>> fetchAdvice(int recordId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('${ApiService.adviceUrl}/$recordId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      // 打印原始响应内容
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        // 将响应的body转换为UTF-8编码
        var utf8Body = utf8.decode(response.bodyBytes);

        // 打印UTF-8编码后的内容
        print('UTF-8 decoded body: $utf8Body');

        Map<String, dynamic> jsonData = json.decode(utf8Body);

        String adviceText = jsonData["adviceText"];
        var adviceJson = jsonDecode(adviceText);

        // 打印解析后的JSON数据
        print('Formatted Advice JSON: $adviceJson');

        return adviceJson;
      } else {
        print('Failed to load advice: ${response.body}');
        return {"error": "Failed to load advice: ${response.body}"};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {"error": "Error occurred: $e"};
    }
  }
}
