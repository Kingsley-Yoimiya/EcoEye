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
        title: Text(
          '植识通-你的随身植物专家',
          style: TextStyle(
            fontFamily: 'Kaiti',
          ),
        ),
        centerTitle: true,
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
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                ),
                child: Text('上传图片！',style: TextStyle(fontFamily: 'Songti',),),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildHistorySection(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryRecordScreen()),
            ),
            child: Text('更多历史记录',style: TextStyle(fontFamily: 'Songti',),),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Record 1'),
                  subtitle: Text('2021-01-01'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultDisplayScreen(results: 'Sample Results')), // 需要调整参数
                  ),
                ),
              ),
              // 添加更多 Card 来展示其他记录
            ],
          ),
        ),
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
