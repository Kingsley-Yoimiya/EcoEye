import 'package:flutter/material.dart';
import '../controllers/history_controller.dart';
import 'dart:convert';

class AdviceDisplayScreen extends StatefulWidget {
  final int recordId;

  AdviceDisplayScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _AdviceDisplayScreenState createState() => _AdviceDisplayScreenState();
}

class _AdviceDisplayScreenState extends State<AdviceDisplayScreen> {
  late Future<Map<String, dynamic>> advice;
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    advice = _historyController.fetchAdvice(widget.recordId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Care Advice',
          style: TextStyle(
            fontFamily: 'Kaiti',
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: advice,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontSize: 18,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            var adviceData = snapshot.data!;
            var advices = adviceData['advice_list']['advices'];
            var result = adviceData['result'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                // 添加 SingleChildScrollView 包裹内容
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.shade50, // 使用更浅的颜色
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '建议列表：',
                            style: TextStyle(
                              fontFamily: 'Songti',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...advices.map<Widget>((advice) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '⭐️' * advice['star'] +
                                      ' ' +
                                      advice['summary'],
                                  style: TextStyle(
                                    fontFamily: 'Songti',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  advice['content'],
                                  style: TextStyle(
                                    fontFamily: 'Songti',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  advice['purpose'],
                                  style: TextStyle(
                                    fontFamily: 'Songti',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1,
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50, // 使用更浅的颜色
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '改善结果：',
                            style: TextStyle(
                              fontFamily: 'Songti',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '主要改善: ${result['major_improvement']}',
                            style: TextStyle(
                              fontFamily: 'Songti',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '详细改善情况: ${result['improvement_details'].join('\n')}',
                            style: TextStyle(
                              fontFamily: 'Songti',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "No advice available",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontSize: 18,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
