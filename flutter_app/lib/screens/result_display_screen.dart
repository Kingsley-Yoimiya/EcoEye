import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'advice_display_screen.dart';
import 'dart:typed_data';

class ResultDisplayScreen extends StatefulWidget {
  final int? recordId;

  ResultDisplayScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _ResultDisplayScreenState createState() => _ResultDisplayScreenState();
}

class _ResultDisplayScreenState extends State<ResultDisplayScreen> {
  String? _resultText;
  Uint8List? _resultImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mocked API request, replace this with your actual API endpoint
      final response = await http.get(Uri.parse('http://example.com/api/analysis/${widget.recordId}'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _resultText = jsonResponse['resultText'];
          _resultImage = base64.decode(jsonResponse['resultImage']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _resultText = 'Failed to retrieve result';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _resultText = 'Error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_resultImage != null)
                  Image.memory(_resultImage!, fit: BoxFit.cover),
                if (_resultText != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_resultText!),
                  ),
                ElevatedButton(
                  onPressed: () {
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
