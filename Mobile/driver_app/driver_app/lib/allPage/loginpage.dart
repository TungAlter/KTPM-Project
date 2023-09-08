import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String username, String password) async {
    const String apiUrl =
        'https://aa90-113-185-76-248.ngrok-free.app/api/Auth/login';

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
      // Thực hiện các thao tác sau khi đăng nhập thành công
    } else {
      // Xử lý lỗi đăng nhập
      print('Đăng nhập thất bại');
      print(response.statusCode);
      print(response.body);
      // Hiển thị thông báo lỗi cho người dùng hoặc thực hiện các xử lý khác dựa trên lỗi.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
