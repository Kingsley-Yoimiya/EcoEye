import 'package:flutter/material.dart';
import 'dart:convert';
import '../controllers/history_controller.dart';
import 'result_display_screen.dart';

class HistoryRecordScreen extends StatefulWidget {
  @override
  _HistoryRecordScreenState createState() => _HistoryRecordScreenState();
}

class _HistoryRecordScreenState extends State<HistoryRecordScreen> {
  final HistoryController _controller = HistoryController();

  Future<List<dynamic>> _fetchHistory() async {
    String historyJson = await _controller.fetchHistory("user123"); // 使用示例用户ID
    return jsonDecode(historyJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Records'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var record = snapshot.data![index];
                return ListTile(
                  title: Text("Record ${record['id']}"),
                  subtitle: Text("Date: ${record['timestamp']}"),
                  onTap: () {
                    // 假设结果页面接受分析结果作为参数
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultDisplayScreen(results: record['analysisResults'].toString())),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
