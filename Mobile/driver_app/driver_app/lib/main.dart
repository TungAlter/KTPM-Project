import 'package:flutter/material.dart';
import 'allPage/loginpage.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Sử dụng LoginPage ở đây
    );
  }
}
