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
    if (analysisResults == null) return SizedBox();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _parseAnalysisResults(analysisResults),
        ),
      ),
    );
  }

  List<Widget> _parseAnalysisResults(String analysisResults) {
    List<Widget> result = [];
    List<String> lines = analysisResults.split("\n");

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.trim().isEmpty) continue;

      result.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            line,
            style: TextStyle(
              fontFamily: 'Songti',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );

      // 生成附注
      String note = _getNoteForLine(line);
      result.add(
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
            child: Text(
              note,
              style: TextStyle(
                fontFamily: 'Songti',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );

      // 添加分割线
      if (i < lines.length - 1) {
        result.add(Divider());
      }
    }

    return result;
  }

  String _getNoteForLine(String line) {
    if (line.contains("X4")) {
      return "木材密度反映了植物的结构和功能特性。";
    } else if (line.contains("X11")) {
      return "比叶面积反映了叶片的投资回报策略。";
    } else if (line.contains("X18")) {
      return "植物高度是植物竞争能力的重要指标。";
    } else if (line.contains("X26")) {
      return "种子干质量反映了植物的繁殖策略和适应性。";
    } else if (line.contains("X50")) {
      return "叶氮含量是衡量植物光合作用潜力的重要指标。";
    } else if (line.contains("X3112")) {
      return "叶面积影响植物的光捕获能力和蒸腾速率。";
    }
    return "";
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
