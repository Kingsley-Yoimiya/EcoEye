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

      String shortInfo = line.split(':')[0];
      String value = line.split(':')[1];
      String shortDescription = _getShortDescription(shortInfo.trim());
      String longInfo = _getFullDescription(line.split(':')[0].trim());

      result.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$shortInfo: $value",
              style: TextStyle(
                fontFamily: 'Songti',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ExpansionTile(
              title: Text(
                "$shortInfo$shortDescription",
                style: TextStyle(
                  fontFamily: 'Songti',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    longInfo,
                    style: TextStyle(
                      fontFamily: 'Songti',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      );
    }

    return result;
  }

  String _getShortDescription(String indicator) {
    switch (indicator) {
      case 'X4(木材密度，SSD)':
        return '反映了植物的结构和功能特性';
      case 'X11(比叶面积，SLA)':
        return '是植物叶片经济谱系中的关键参数，反映了叶片的投资回报策略';
      case 'X18(植物高度)':
        return '是植物竞争能力的一个重要指标';
      case 'X26(种子干质量)':
        return '反映了植物的繁殖策略和适应性。';
      case 'X50(叶氮含量)':
        return '是衡量植物光合作用潜力和叶片质量的重要指标。';
      case 'X3112(叶面积)':
        return '影响植物的光捕获能力和蒸腾速率。';
      default:
        return '';
    }
  }

  String _getFullDescription(String indicator) {
    switch (indicator) {
      case 'X4(木材密度，SSD)':
        return '木材密度（Specific Stem Density, SSD）是指单位体积木材的干重，通常以克每立方厘米（g/cm³）表示。木材密度反映了植物的结构和功能特性，高密度木材通常意味着较高的机械强度和抗风能力，但也可能意味着较慢的生长速度。低密度木材则常与快速生长和较高的光合作用效率相关。';
      case 'X11(比叶面积，SLA)':
        return '比叶面积（Specific Leaf Area, SLA）是单位叶片干重的叶面积，通常以平方毫米每克（mm²/g）表示。SLA是植物叶片经济谱系中的关键参数，反映了叶片的投资回报策略。较高的SLA值通常与较高的光合作用率和较短的叶片寿命相关，适合快速生长的环境。较低的SLA值则表明叶片更厚实，寿命更长，适合资源匮乏的环境。';
      case 'X18(植物高度)':
        return '植物高度指的是植物从根部到顶端的高度，通常以米（m）表示。植物高度是植物竞争能力的一个重要指标，较高的植物通常在光竞争中具有优势，能够更有效地捕获光资源。但高度也受制于生理和机械限制，过高的植物可能更易受风力或重力影响。';
      case 'X26(种子干质量)':
        return '种子干质量是指单个种子的干重，通常以毫克（mg）表示。种子干质量反映了植物的繁殖策略和适应性。较大、较重的种子通常具有更多的储存能量，能够在不利环境下提供幼苗更好的生存机会。较小、较轻的种子则往往数量更多，有助于更广泛的传播和快速占领空地。';
      case 'X50(叶氮含量)':
        return '叶氮含量是叶片中氮元素的含量，通常以叶片干重的百分比（%）表示。叶氮含量是衡量植物光合作用潜力和叶片质量的重要指标。高氮含量通常与高光合作用效率和快速生长相关，而低氮含量则可能表明叶片在贫瘠土壤中的适应性和较长的寿命。';
      case 'X3112(叶面积)':
        return '叶面积是单个叶片的表面积，通常以平方厘米（cm²）表示。叶面积影响植物的光捕获能力和蒸腾速率。较大的叶面积可以提高光合效率，但也可能导致较高的水分散失风险。在不同环境条件下，叶面积的优化是植物适应环境变化的关键。';
      default:
        return '';
    }
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
