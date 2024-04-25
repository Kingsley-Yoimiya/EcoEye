import 'package:flutter/material.dart';
import 'advice_display_screen.dart';

class ResultDisplayScreen extends StatelessWidget {
  final String results; // 假设这是分析结果的字符串表示

  ResultDisplayScreen({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(results), // 展示分析结果
          ),
          ElevatedButton(
            onPressed: () {
              // 导航到 AdviceDisplayScreen，这里传递的内容应由实际应用逻辑决定
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdviceDisplayScreen(advice: 'Keep it in a cool, dry place.')),
              );
            },
            child: Text('View Care Advice'),
          ),
        ],
      ),
    );
  }
}
