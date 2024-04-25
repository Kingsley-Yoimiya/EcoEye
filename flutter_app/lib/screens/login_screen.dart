import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '../controllers/user_management_controller.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  final UserManagementController _controller = UserManagementController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showDialog(String title, String content) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CustomInputField(hintText: 'Username', controller: _usernameController),
            CustomInputField(hintText: 'Password', controller: _passwordController, obscureText: true),
            CustomButton(
              text: 'Login',
              onPressed: () async {
                final loginResponse = await _controller.loginUser(_usernameController.text, _passwordController.text);
                if (loginResponse == "Login successful") {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                } else {
                  _showDialog("Login Failed", loginResponse);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
