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
        title: Text(
          '记录详情',
          style: TextStyle(
            fontFamily: 'Kaiti',
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: recordDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // 记录概况小块，添加操作按钮
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "记录 ID: ${snapshot.data?["recordId"]}",
                                style: TextStyle(
                                  fontFamily: 'Songti',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "时间戳: ${snapshot.data?["timestamp"]}",
                                style: TextStyle(fontFamily: 'Songti'),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    // 实现重新分析功能
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // 实现删除记录功能
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.lightbulb_outline),
                                  onPressed: () {
                                    // 实现获取植物养护建议功能
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 分析结果小块
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "分析结果: ${snapshot.data?["analysisResults"]}",
                          style: TextStyle(fontFamily: 'Songti'),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 图片小块
                    snapshot.data?["photo"] != null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(snapshot.data!["photo"],
                                  fit: BoxFit.cover),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
