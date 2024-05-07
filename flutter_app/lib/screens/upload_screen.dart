import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../widgets/button.dart'; // 根据实际路径调整
import '../controllers/upload_and_analysis_controller.dart'; // 根据实际路径调整
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadAndAnalysisController _controller = UploadAndAnalysisController();
  Uint8List? _selectedImage;
  String? _filename;
  bool _isLoggedIn = false;
  bool _isUploaded = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
        Uint8List imageBytes = await image.readAsBytes();
        setState(() {
            _selectedImage = imageBytes;
            _filename = image.name;
            _isUploaded = false;
        });
    }
  }



   Future<void> _uploadImage() async {
    if (!_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请先登录')),
      );
      return;
    }

    if (_selectedImage != null && _filename != null) {
      final response = await _controller.uploadPhoto(_selectedImage!, _filename!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
      if (response == "File uploaded successfully") {
        setState(() {
          _isUploaded = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请先选择一张图片')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '上传图片',
          style: TextStyle(
            fontFamily: 'Kaiti',
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DottedBorder(
              color: Colors.blue,
              strokeWidth: 2,
              dashPattern: [6, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.white,
                child: Center(
                  child: _selectedImage != null
                      ? Image.memory(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Text('No image selected.'),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: '选择图片',
                onPressed: _pickImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: '上传',
                onPressed: _isLoggedIn ? _uploadImage : (){},
              ),
            ),
            if (!_isLoggedIn)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '请先登录或注册以使用此功能',
                  style: TextStyle(
                    fontFamily: 'Songti',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
