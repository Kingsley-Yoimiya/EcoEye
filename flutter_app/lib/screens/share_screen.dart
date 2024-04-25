import 'package:flutter/material.dart';
import '../controllers/share_controller.dart';

class ShareScreen extends StatelessWidget {
  final ShareController _controller = ShareController();

  void _shareContent(BuildContext context, String platform) async {
    String response = await _controller.shareContent(platform, "Check out my latest analysis!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _shareContent(context, "Twitter"),
              child: Text('Share on Twitter'),
            ),
            ElevatedButton(
              onPressed: () => _shareContent(context, "Facebook"),
              child: Text('Share on Facebook'),
            ),
            // 可以根据需要添加更多分享平台的按钮
          ],
        ),
      ),
    );
  }
}
