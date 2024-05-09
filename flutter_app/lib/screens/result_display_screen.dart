import 'package:flutter/material.dart';
import 'dart:convert';
import '../controllers/history_controller.dart';

class ResultDisplayScreen extends StatefulWidget {
  final int recordId;

  ResultDisplayScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _ResultDisplayScreenState createState() => _ResultDisplayScreenState();
}

class _ResultDisplayScreenState extends State<ResultDisplayScreen> {
  late Future<Map<String, dynamic>> recordDetail;
  HistoryController _historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    recordDetail = _historyController.fetchRecordDetail(widget.recordId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: recordDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ListView(
              children: <Widget>[
                Text("Record ID: ${snapshot.data?["recordId"]}"),
                Text("Timestamp: ${snapshot.data?["timestamp"]}"),
                Text("Analysis Results: ${snapshot.data?["analysisResults"]}"),
                // 显示照片，假设是通过URL访问的
                Image.network(snapshot.data?["photo"]),
              ],
            );
          }
        },
      ),
    );
  }
}
