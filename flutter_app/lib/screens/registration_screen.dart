import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '../controllers/user_management_controller.dart';
import '../utils/validators.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final UserManagementController _controller = UserManagementController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '注册',
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
                  child: CustomInputField(
                    hintText: '电子邮件',
                    controller: _emailController,
                    validator: Validators.emailValidator,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: '注册',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String result = await _controller.registerUser(
                          _usernameController.text,
                          _passwordController.text,
                          _emailController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                        if (result == "User created successfully") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
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
