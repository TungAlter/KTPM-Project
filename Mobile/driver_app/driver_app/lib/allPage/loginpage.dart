import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mainpage.dart'; // Import màn hình MainPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> loginUser(String username, String password) async {
    const String apiUrl =
        'https://16e9-2001-ee0-4fc8-7ac0-894f-c0fd-15fa-64a7.ngrok-free.app/api/Auth/login';

    final Map<String, dynamic> postData = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(postData),
    );

    if (response.statusCode == 200) {
      // Xử lý kết quả đăng nhập thành công
      print('Đăng nhập thành công');
      print(response.body);

      // Hiển thị thông báo đăng nhập thành công nếu Scaffold không phải là null
      _showSnackBar('Đăng nhập thành công');

      // Điều hướng sang màn hình MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    } else {
      // Xử lý lỗi đăng nhập
      print('Đăng nhập thất bại');
      print(response.statusCode);
      print(response.body);

      // Hiển thị thông báo lỗi cho người dùng nếu Scaffold không phải là null
      _showSnackBar('Đăng nhập thất bại');
    }
  }

// Hàm hiển thị SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Đặt key cho Scaffold
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người dùng',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Gọi hàm đăng nhập khi người dùng nhấn nút Đăng nhập
                  String username = usernameController.text;
                  String password = passwordController.text;
                  loginUser(username, password);
                },
                child: const Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
