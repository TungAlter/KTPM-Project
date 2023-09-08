import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerDriver(String email, String password) async {
  const String apiUrl = 'https://10.0.2.2:7295/api/Auth/register-driver';

  final Map<String, dynamic> postData = {
    'email': email,
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
    // Xử lý kết quả thành công
    print('Đăng ký thành công');
    print(response.body);
  } else {
    // Xử lý lỗi
    print('Đăng ký thất bại');
    print(response.statusCode);
    print(response.body);
  }
}
