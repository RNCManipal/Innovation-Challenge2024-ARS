import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart'; // Add permission_handler

import 'BluetoothManager.dart'; // Import the global manager
import 'location.dart'; // Import the Location class

class BluetoothHandler extends StatefulWidget {
  final BuildContext context;

  const BluetoothHandler(this.context, {super.key});

  @override
  _BluetoothHandlerState createState() => _BluetoothHandlerState();
}

class _BluetoothHandlerState extends State<BluetoothHandler> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndConnect();
  }

  Future<void> _checkPermissionsAndConnect() async {
    // Request Bluetooth permissions for Android 12+
    if (await _requestBluetoothPermissions()) {
      await _connectToHC05();
    } else {
      print('Bluetooth or location permissions not granted');
    }
  }

  Future<bool> _requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      return true;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> _connectToHC05() async {
    FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    BluetoothDevice? hc05Device;

    for (var device in devices) {
      if (device.name == 'HC-05') {
        hc05Device = device;
        break;
      }
    }

    if (hc05Device != null) {
      try {
        await BluetoothManager().connectToDevice(hc05Device.address);
        setState(() {
          isConnected = true;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            widget.context,
            MaterialPageRoute(builder: (context) => Location()),
          );
        });
      } catch (error) {
        print('Cannot connect, exception occurred: $error');
        BluetoothManager().disconnect();
      }
    } else {
      print('HC-05 device not found');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isConnected
            ? const CircularProgressIndicator()
            : Text('Connecting to Bluetooth...'),
      ),
    );
  }
}
