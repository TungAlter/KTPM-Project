import 'dart:async'; // Thêm dòng này để import gói dart:async

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/Allwidgets/Divider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 165.0,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile Name",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text("Visit Profile"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const DividerWidget(),
              const SizedBox(
                height: 12.0,
              ),
              const ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "History",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Visit Profile",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "About",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              if (!_controllerGoogleMap.isCompleted) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
              }
            },
          ),
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 400.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6.0,
                    ),
                    const Text(
                      "Hi there ",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    const Text(
                      "Where to ?,",
                      style:
                          TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.lightBlueAccent,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Search Drop Off")
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Home"),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Your living home address",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.0),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    const Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add work"),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Your office address",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.0),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
