import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '../controllers/user_management_controller.dart';
import '../utils/validators.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  final UserManagementController _controller = UserManagementController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        title: Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomInputField(
                    hintText: '用户名',
                    controller: _usernameController,
                    validator: Validators.usernameValidator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomInputField(
                    hintText: '密码',
                    controller: _passwordController,
                    obscureText: true,
                    validator: Validators.passwordValidator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: '登录',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final loginResponse = await _controller.loginUser(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        if (loginResponse == "Login successful") {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => MainScreen()),
                            (route) => false,
                          );
                        } else {
                          _showDialog("登录失败", loginResponse);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
