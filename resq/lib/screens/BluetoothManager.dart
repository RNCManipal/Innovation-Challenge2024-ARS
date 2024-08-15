import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothConnection? connection;

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  Future<void> connectToDevice(String deviceAddress) async {
    if (connection != null && connection!.isConnected) {
      print('Already connected to a device.');
      return; // Already connected
    }

    try {
      connection = await BluetoothConnection.toAddress(deviceAddress);
      print('Connected to the device: $deviceAddress');
    } catch (e) {
      print('Failed to connect to the device: $e');
      connection = null; // Ensure connection is set to null on failure
    }
  }

  void disconnect() {
    if (connection != null) {
      connection!.dispose();
      connection = null;
      print('Disconnected from the device.');
    }
  }
}
