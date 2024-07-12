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
  late StreamSubscription subscription;
  bool trackingEnabled = false;

  LatLng? currentLocation;
  GoogleMapController? mapController;
  CameraPosition? initialCameraPosition;

  @override
  void initState() {
    super.initState();
    // Ensure MediaQuery is available before accessing size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initialCameraPosition = const CameraPosition(
          target: LatLng(0.0, 0.0), // Set your default initial position here
          zoom: 15.0,
        );
      });
    });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildListTile(
              "GPS",
              gpsEnabled
                  ? const Text("Okey")
                  : ElevatedButton(
                      onPressed: () {
                        requestEnableGps();
                      },
                      child: const Text("Enable Gps")),
            ),
            buildListTile(
              "Permission",
              permissionGranted
                  ? const Text("Okey")
                  : ElevatedButton(
                      onPressed: () {
                        requestLocationPermission();
                      },
                      child: const Text("Request Permission")),
            ),
            buildListTile(
              "Location",
              trackingEnabled
                  ? ElevatedButton(
                      onPressed: () {
                        stopTracking();
                      },
                      child: const Text("Stop"))
                  : ElevatedButton(
                      onPressed: gpsEnabled && permissionGranted
                          ? () {
                              startTracking();
                            }
                          : null,
                      child: const Text("Start")),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: initialCameraPosition ??
                    const CameraPosition(
                      target: LatLng(0.0,
                          0.0), // Fallback position if initialCameraPosition is null
                      zoom: 15.0,
                    ),
                markers: Set.of(_createMarkers()),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                onTap: (LatLng latLng) {
                  // Handle map tap if needed
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(
    String title,
    Widget? trailing,
  ) {
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
      if (!isGpsActive) {
        setState(() {
          gpsEnabled = false;
        });
        log("User did not turn on GPS");
      } else {
        log("Gave permission to the user and opened it");
        setState(() {
          gpsEnabled = true;
        });
      }
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        permissionGranted = true;
      });
    } else {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  void checkStatus() async {
    bool permission = await isPermissionGranted();
    bool gps = await isGpsEnabled();
    setState(() {
      permissionGranted = permission;
      gpsEnabled = gps;
    });
  }

  Set<Marker> _createMarkers() {
    if (currentLocation != null) {
      return {
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    } else {
      return {};
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void addLocation(l.LocationData data) {
    setState(() {
      currentLocation = LatLng(data.latitude!, data.longitude!);
    });
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void clearLocation() {
    setState(() {
      currentLocation = null;
    });
  }

  void startTracking() async {
    if (!(await isGpsEnabled())) {
      return;
    }
    if (!(await isPermissionGranted())) {
      return;
    }
    subscription = location.onLocationChanged.listen((l.LocationData event) {
      addLocation(event);
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
    clearLocation();
  }
}
