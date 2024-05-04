import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/history_controller.dart';
import 'result_display_screen.dart';

class HistoryRecordScreen extends StatefulWidget {
  @override
  _HistoryRecordScreenState createState() => _HistoryRecordScreenState();
}

class _HistoryRecordScreenState extends State<HistoryRecordScreen> {
  final HistoryController _controller = HistoryController();
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    List<Map<String, dynamic>> historyData;

    if (userId != null) {
      historyData = await _controller.fetchHistory(userId);
    } else {
      historyData = [
        {
          "recordId": 0,
          "userId": 0,
          "timestamp": 0,
          "status": "User not logged in"
        },
        // {
        //   "recordId": 114514,
        //   "userId": 0,
        //   "timestamp": "2024.1.2",
        //   "status": "Success"
        // },
        // {
        //   "recordId": 0,
        //   "userId": 0,
        //   "timestamp": "2024.1.2",
        //   "status": "Failed to load history"
        // }
      ];
    }

    setState(() {
      historyList = historyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录', style: TextStyle(fontFamily: 'Kaiti', fontWeight: FontWeight.bold, fontSize: 23)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildHistorySection(context),
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
