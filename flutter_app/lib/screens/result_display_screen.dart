import 'package:flutter/material.dart';
import 'dart:convert';
import '../controllers/history_controller.dart';
import '../screens/advice_display_screen.dart';

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
                                  onPressed: () async {
                                    var result = await _historyController
                                        .reanalyzeRecord(widget.recordId);
                                    if (result["status"] == "Success") {
                                      // 可以选择重新加载记录详情或者直接更新界面
                                      setState(() {
                                        recordDetail = Future.value(result);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text("重新分析成功")),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(result["status"])),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    String message = await _historyController
                                        .deleteRecord(widget.recordId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                    if (message ==
                                        "Record deleted successfully") {
                                      // 删除成功后，返回到上一个界面或者主界面
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.lightbulb_outline),
                                  onPressed: () {
                                    // 使用 Navigator 导向 AdviceDisplayScreen，并传递 recordId
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdviceDisplayScreen(
                                                recordId: widget.recordId),
                                      ),
                                    );
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
