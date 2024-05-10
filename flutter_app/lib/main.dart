import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/result_display_screen.dart';
import 'screens/advice_display_screen.dart';
import 'screens/history_record_screen.dart';
import 'screens/share_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the routes
      routes: {
        '/': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/upload': (context) => UploadScreen(),
        '/result': (context) => ResultDisplayScreen(
              recordId: 0,
            ), // You need to adjust this according to how you plan to pass results
        '/advice': (context) => AdviceDisplayScreen(
              recordId: 0,
            ), // Adjust based on how you pass advice
        '/history': (context) => HistoryRecordScreen(),
        '/share': (context) => ShareScreen(),
      },
      initialRoute: '/', // Set the initial route
    );
  }
}
