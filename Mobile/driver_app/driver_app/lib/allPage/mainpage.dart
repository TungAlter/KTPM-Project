import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController mapController;
  late LocationData currentLocation; // Lưu thông tin vị trí hiện tại của tài xế
  Location location = Location();
  Set<Marker> markers = <Marker>{}; // Danh sách các Marker

  @override
  void initState() {
    super.initState();
    // Gọi hàm để lấy vị trí hiện tại của tài xế và hiển thị marker mặc định
    _getCurrentLocation();
    // Thêm marker mặc định
    _addDefaultMarker();
  }

  // Hàm để lấy vị trí hiện tại của tài xế và hiển thị marker vị trí hiện tại
  Future<void> _getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      double latitude = currentLocation.latitude ?? 0.0;
      double longitude = currentLocation.longitude ?? 0.0;

      // Đặt vị trí hiện tại làm vị trí ban đầu trên bản đồ
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Hàm để thêm marker mặc định
  void _addDefaultMarker() {
    // Tạo một Marker mặc định
    Marker defaultMarker = const Marker(
      markerId: MarkerId("defaultMarker"),
      position: LatLng(0.0, 0.0), // Điểm mặc định, bạn có thể thay đổi
      infoWindow: InfoWindow(title: "Điểm mặc định"),
    );

    // Thêm Marker vào danh sách các Marker
    markers.add(defaultMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0,
                  0.0), // Giá trị mặc định, sẽ thay đổi sau khi lấy vị trí hiện tại
              zoom: 14.0,
            ),
            markers: markers, // Hiển thị danh sách các Marker
            zoomControlsEnabled: true, // Hiển thị nút zoom
          ),
          Positioned(
            bottom: 220.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút "Sẵn sàng" để nhận booking taxi
                // Thêm mã xử lý ở đây
              },
              child: const Text('Sẵn sàng'),
            ),
          ),
          Positioned(
            bottom: 150.0,
            right: 5.0,
            child: FloatingActionButton(
              onPressed: () {
                // Xử lý khi nhấn nút "Vị trí hiện tại"
                _getCurrentLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
