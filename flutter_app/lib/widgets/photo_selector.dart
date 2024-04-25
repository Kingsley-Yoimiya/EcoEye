import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoSelector extends StatefulWidget {
  @override
  _PhotoSelectorState createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _selectedImage = File(image.path);
      }
    });
  }

  File? get selectedImage => _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectedImage != null ? Image.file(_selectedImage!) : Text('No image selected.'),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Select Image'),
        ),
      ],
    );
  }
}
