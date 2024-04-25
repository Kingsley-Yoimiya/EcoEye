import 'package:flutter/material.dart';

class AdviceDisplayScreen extends StatelessWidget {
  final String advice; // 假设这是养护建议的字符串表示

  AdviceDisplayScreen({Key? key, required this.advice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Advice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(advice), // 展示养护建议
      ),
    );
  }
}
