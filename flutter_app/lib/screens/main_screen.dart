import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'upload_screen.dart';
import 'history_record_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              ),
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadScreen()),
              ),
              child: Text('Upload'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryRecordScreen()),
              ),
              child: Text('View History'),
            ),
          ],
        ),
      ),
    );
  }
}
