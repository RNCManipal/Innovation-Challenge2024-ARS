import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription<l.LocationData> subscription;
  bool trackingEnabled = false;

  late GoogleMapController mapController;
  Marker? userMarker;

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15.0,
              ),
              markers: userMarker != null ? {userMarker!} : {},
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),
          buildListTile(
            "GPS",
            gpsEnabled
                ? const Text("Okey")
                : ElevatedButton(
                    onPressed: requestEnableGps,
                    child: const Text("Enable Gps")),
          ),
          buildListTile(
            "Permission",
            permissionGranted
                ? const Text("Okey")
                : ElevatedButton(
                    onPressed: requestLocationPermission,
                    child: const Text("Request Permission")),
          ),
          buildListTile(
            "Location",
            trackingEnabled
                ? ElevatedButton(
                    onPressed: stopTracking, child: const Text("Stop"))
                : ElevatedButton(
                    onPressed:
                        gpsEnabled && permissionGranted ? startTracking : null,
                    child: const Text("Start")),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(String title, Widget? trailing) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: trailing,
    );
  }

  void requestEnableGps() async {
    if (gpsEnabled) {
      log("Already open");
    } else {
      bool isGpsActive = await location.requestService();
      setState(() {
        gpsEnabled = isGpsActive;
      });
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    setState(() {
      permissionGranted = permissionStatus == PermissionStatus.granted;
    });
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  checkStatus() async {
    bool permissionGranted = await isPermissionGranted();
    bool gpsEnabled = await isGpsEnabled();
    setState(() {
      this.permissionGranted = permissionGranted;
      this.gpsEnabled = gpsEnabled;
    });
  }

  void startTracking() async {
    if (!(await isGpsEnabled())) {
      return;
    }
    if (!(await isPermissionGranted())) {
      return;
    }
    subscription = location.onLocationChanged.listen((event) {
      updateLocation(event);
    });
    setState(() {
      trackingEnabled = true;
    });
  }

  void stopTracking() {
    subscription.cancel();
    setState(() {
      trackingEnabled = false;
    });
  }

  void updateLocation(l.LocationData data) {
    LatLng newPosition = LatLng(data.latitude!, data.longitude!);
    setState(() {
      userMarker = Marker(
        markerId: const MarkerId('userMarker'),
        position: newPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
    mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
  }
}

