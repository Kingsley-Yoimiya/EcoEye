import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/button.dart'; // 根据实际路径调整
import '../controllers/upload_and_analysis_controller.dart'; // 根据实际路径调整
import 'dart:io';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadAndAnalysisController _controller = UploadAndAnalysisController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _selectedImage = File(image.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      final response = await _controller.uploadPhoto(_selectedImage!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _selectedImage != null
              ? Image.file(_selectedImage!)
              : Text('No image selected.'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Select Image',
              onPressed: _pickImage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Upload',
              onPressed: _uploadImage,
            ),
          ),
        ],
      ),
    );
  }
}
