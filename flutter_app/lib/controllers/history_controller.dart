import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class HistoryController {
  Future<String> fetchHistory(String userId) async {
    try {
      var response = await http.get(Uri.parse('${ApiService.historyUrl}/$userId'));
      if (response.statusCode == 200) {
        return response.body; // 可能需要解析JSON
      } else {
        return "Failed to load history";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }
}
