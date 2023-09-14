import 'package:flutter/material.dart';
import 'package:driver_app/pages/order_tracking_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: <Widget>[
      buildTop(),
      buildContent(),
    ]));
  }

  Widget buildTop() {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: buildCoverImg(),
          ),
          Positioned(top: 200, child: buildProfileImage())
        ]);
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận Order'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Số điện thoại của khách: 0878289687'), // Thay phoneNumber bằng số điện thoại của khách từ API
              Text(
                  'Địa điểm đón: 135 Trần Hưng Đạo'), // Thay sourceLocation bằng địa điểm đi từ API
              Text(
                  'Địa điểm đến: 227 Nguyễn Văn Cừ'), // Thay destination bằng địa điểm đến từ API
              Text(
                  'Tổng tiền: 57.000 VNĐ'), // Thay totalAmount bằng tổng tiền từ API
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Từ chối'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý khi người dùng xác nhận
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OrderTrackingPage(),
                  ),
                );
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 4),
          const Text(
            'James Summer',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '09651877624',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8),
                  Text(
                    'Date of birth: 2/1/2002',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text(
                    'Giới tính: Nam',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 8),
                  Text(
                    'Rating: 4.5',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            // Đặt Container trên nút "Sẵn sàng"
            alignment: Alignment.center,
            color: Colors.grey[200], // Màu nền của danh sách
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text(
                  'Các chuyến xe gần đây:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // Bổ sung các phần tử danh sách ở đây, ví dụ:
                Text('9:00 - 13/9/2002 - 60.000 VNĐ'),
                Text('8:00 - 13/9/2002 - 49.000 VNĐ'),
                Text('7:00 - 13/9/2002 - 30.000 VNĐ'),
                // Thêm các mục khác theo yêu cầu của bạn
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Doanh thu trong ngày hôm nay: 500.000 VNĐ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nút được nhấn
              // Ví dụ: Chuyển sang trạng thái sẵn sàng
              _showConfirmationDialog(context); // Hiển thị hộp thoại xác nhận
            },
            child: const Text('Sẵn sàng'),
          ),
        ],
      );

  Widget buildCoverImg() => Container(
        color: Colors.grey,
        child: Image.network(
          'https://images.unsplash.com/photo-1561296160-7ea9d1b5511d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
          width: double.infinity,
          height: 280,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: 144 / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const NetworkImage(
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=880&q=80',
        ),
      );
}
