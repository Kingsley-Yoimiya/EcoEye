import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/button.dart';
import '../controllers/user_management_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final UserManagementController _controller = UserManagementController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CustomInputField(hintText: 'Username', controller: _usernameController),
            CustomInputField(hintText: 'Password', controller: _passwordController, obscureText: true),
            CustomInputField(hintText: 'Email', controller: _emailController),
            CustomButton(
              text: 'Register',
              onPressed: () {
                // Implement registration logic using _controller
              },
            ),
          ],
        ),
      ),
    );
  }
}
