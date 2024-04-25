class ApiService {
  // 基础URL
  static const String baseUrl = 'http://yourapi.com/api';

  // 用户管理相关的URL
  static const String registerUrl = '$baseUrl/register';
  static const String loginUrl = '$baseUrl/login';

  // 历史记录相关的URL
  static const String historyUrl = '$baseUrl/history';

  // 上传和分析相关的URL
  static const String uploadUrl = '$baseUrl/upload';
  static const String analyzeUrl = '$baseUrl/analyze';

  // 分享相关的URL
  static const String shareUrl = '$baseUrl/share';
}
