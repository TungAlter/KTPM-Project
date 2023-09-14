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

  static const LatLng sourceLocation =
      LatLng(10.767173989580376, 106.69487859999944);
  static const LatLng destination =
      LatLng(10.762732391550383, 106.68228327994437);

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

  void completeOrder() {
    // Hiển thị SnackBar để thông báo đơn hàng đã hoàn thành
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order completed'),
        backgroundColor: Colors.green, // Màu nền của SnackBar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String estimatedArrivalTime = "15 minutes"; // Thời gian tới nơi
    String destinationAddress = "123 ABC Street"; // Địa chỉ đến
    String pickupAddress = "456 XYZ Street"; // Địa chỉ đi

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: Text("Loading"))
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation != null
                          ? LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            )
                          : const LatLng(0.0, 0.0),
                      zoom: 13.5,
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.blue,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(
                          currentLocation != null
                              ? currentLocation!.latitude!
                              : 0.0,
                          currentLocation != null
                              ? currentLocation!.longitude!
                              : 0.0,
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
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estimated Arrival Time: $estimatedArrivalTime",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pickup Address: $pickupAddress",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Destination Address: $destinationAddress",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: completeOrder,
                        child: const Text("Complete Order"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
