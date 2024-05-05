import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import '../controllers/history_controller.dart';
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
  String? userId;
  final HistoryController _historyController = HistoryController();
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      userId = prefs.getString('userId');
    });

    if (userId != null) {
      _loadHistory(userId!);
    } else {
      // 用户未登录，设置默认的错误记录
      setState(() {
        historyList = [
          {
            "recordId": 0,
            "userId": 0,
            "timestamp": 0,
            "status": "User not logged in"
          }
        ];
      });
    }
  }

  _loadHistory(String userId) async {
    List<Map<String, dynamic>> historyData = await _historyController.fetchHistory(userId);
    setState(() {
      historyList = historyData.take(10).toList();
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
            fontWeight: FontWeight.bold,
            fontSize: 23,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedBorder(
              color: Colors.blue,
              strokeWidth: 2,
              dashPattern: [6, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.white,
                child: Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadScreen()),
                    ),
                    child: Text('上传图片！', style: TextStyle(fontFamily: 'Songti', fontWeight: FontWeight.bold, fontSize: 18,),),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.transparent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
            child: Text('更多历史记录', style: TextStyle(fontFamily: 'Songti', fontWeight: FontWeight.bold, fontSize: 14,),),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final record = historyList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text("#${record['recordId']}"),
                  subtitle: record["timestamp"] != 0 ? Text("${record['timestamp']}") : null,
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: record['status'] == "Success" ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      record['status'] == "Success" ? "成功" : record['status'] == "User not logged in" ? "失败 | 用户未登录" : "失败",
                      style: TextStyle(fontFamily: 'Songti', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    if (record['status'] != "Success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(record['status'])),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultDisplayScreen(results: "Sample Result")),
                      );
                    }
                  },
                ),
              );
            },
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }
}
