import 'package:flutter/material.dart';
import '../controllers/history_controller.dart';

class AdviceDisplayScreen extends StatefulWidget {
  final int recordId;

  AdviceDisplayScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _AdviceDisplayScreenState createState() => _AdviceDisplayScreenState();
}

class _AdviceDisplayScreenState extends State<AdviceDisplayScreen> {
  late Future<String> advice;
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
        title: Text('Care Advice'),
      ),
      body: FutureBuilder<String>(
        future: advice,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data ?? "No advice available"),
            );
          }
        },
      ),
    );
  }
}
