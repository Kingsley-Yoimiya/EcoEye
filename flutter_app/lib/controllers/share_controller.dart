import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class ShareController {
  Future<String> shareContent(String platform, String content) async {
    try {
      var response = await http.post(
        Uri.parse(ApiService.shareUrl),
        body: {
          'platform': platform,
          'content': content,
        },
      );
      if (response.statusCode == 200) {
        return "Content shared successfully";
      } else {
        return "Failed to share content";
      }
    } catch (e) {
      return "Error occurred: $e";
    }
  }
}
