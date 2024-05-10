import 'package:flutter/material.dart';
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
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontSize: 18,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildRecordOverviewCard(snapshot.data),
                    SizedBox(height: 8),
                    _buildAnalysisResultCard(snapshot.data?["analysisResults"]),
                    SizedBox(height: 8),
                    _buildPhotoCard(snapshot.data?["photo"]),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRecordOverviewCard(Map<String, dynamic>? data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "ID: #${data?["recordId"]}",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "时间: ${data?["timestamp"]}",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.blue),
          onPressed: () => _reanalyzeRecord(),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteRecord(),
        ),
        IconButton(
          icon: Icon(Icons.lightbulb_outline, color: Colors.amber),
          onPressed: () => _navigateToAdviceScreen(),
        ),
      ],
    );
  }

  Widget _buildAnalysisResultCard(String? analysisResults) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "分析结果: \n $analysisResults",
          style: TextStyle(
            fontFamily: 'Songti',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String? photoUrl) {
    if (photoUrl == null) return SizedBox();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(photoUrl, fit: BoxFit.cover),
      ),
    );
  }

  void _reanalyzeRecord() async {
    var result = await _historyController.reanalyzeRecord(widget.recordId);
    if (result["status"] == "Success") {
      setState(() {
        recordDetail = Future.value(result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("重新分析成功")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["status"])),
      );
    }
  }

  void _deleteRecord() async {
    String message = await _historyController.deleteRecord(widget.recordId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    if (message == "Record deleted successfully") {
      // 删除成功后，返回到上一个界面或者主界面
      Navigator.pop(context);
    }
  }

  void _navigateToAdviceScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdviceDisplayScreen(recordId: widget.recordId),
      ),
    );
  }
}
