import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'upload_screen.dart';
import 'history_record_screen.dart';
import 'result_display_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('植识通-你的随身植物专家',
                    style: TextStyle(
                      fontFamily: 'Kaiti',
                    ),
                ),
        actions: <Widget>[
          if (username != null)
            PopupMenuButton<int>(
              onSelected: (item) => _select(item, context),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Logout')),
              ],
            )
          else
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.app_registration),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadScreen()),
            ),
            child: Text('Upload and Analyze Image'),
          ),
          Expanded(
            child: _buildHistorySection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    // 假设这里有一个方法来获取最近的历史记录，这里只是一个占位符
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryRecordScreen()),
            ),
            child: Text('View More'),
          ),
        ),
        // 这里应该根据实际的数据动态构建历史记录列表
        ListTile(
          title: Text('Record 1'),
          subtitle: Text('2021-01-01'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultDisplayScreen(results: 'Sample Results')), // 需要调整参数
          ),
        ),
        // 添加更多 ListTile 来展示其他记录
      ],
    );
  }

  void _select(int item, BuildContext context) {
    switch (item) {
      case 0: // Logout
        _logoutUser(context);
        break;
    }
  }

  void _logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      username = null;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
