import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver_app/constant.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

  void getPoLyPoint() async {
    PolylinePoints polylinePoint = PolylinePoints();

    PolylineResult result = await polylinePoint.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPoLyPoint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation != null
                    ? LatLng(
                        currentLocation!.latitude!, currentLocation!.longitude!)
                    : const LatLng(0.0,
                        0.0), // Vị trí mặc định nếu currentLocation là null
                zoom: 13.5,
              ),
              myLocationButtonEnabled:
                  true, // Cho phép hiển thị nút "Vị trí hiện tại"
              myLocationEnabled:
                  true, // Cho phép sử dụng dịch vụ vị trí để hiển thị vị trí hiện tại
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(
                    currentLocation != null ? currentLocation!.latitude! : 0.0,
                    currentLocation != null ? currentLocation!.longitude! : 0.0,
                  ),
                ),
                const Marker(
                  markerId: MarkerId("source"),
                  position: sourceLocation,
                ),
                const Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                ),
              },
            ),
    );
  }
}
