import 'package:driver_app/pages/login_page.dart';
//import 'package:driver_app/pages/main_page.dart';
//import 'package:driver_app/pages/order_tracking_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
