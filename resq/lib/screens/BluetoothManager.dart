import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothConnection? connection;

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  Future<void> connectToDevice(String deviceAddress) async {
    if (connection != null) {
      return; // Already connected
    }
    connection = await BluetoothConnection.toAddress(deviceAddress);
  }

  void disconnect() {
    connection?.dispose();
    connection = null;
  }
}
