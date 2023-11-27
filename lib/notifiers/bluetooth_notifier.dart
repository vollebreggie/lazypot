import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothNotifier extends ChangeNotifier {
// Some state management stuff
  bool foundDeviceWaitingToConnect = false;
  bool scanStarted = false;
  bool connected = false;

// Bluetooth related variables
  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Uuid characteristicUuid = Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  Stream<ConnectionStateUpdate>? _currentConnectionStream;

  BluetoothNotifier() : super();

  void startScan() async {
    // Platform permissions handling stuff
    scanStarted = true;

    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      await [Permission.location, Permission.storage, Permission.bluetooth, Permission.bluetoothConnect, Permission.bluetoothScan].request();
    }

    var isBluetoothOn = await FlutterBluePlus.instance.isOn;

    if (!isBluetoothOn) {
      isBluetoothOn = await FlutterBluePlus.instance.turnOn();
      return;
    }

    // Main scanning logic happens here ⤵️
    if (isBluetoothOn) {
      _scanStream = flutterReactiveBle.scanForDevices(withServices: [serviceUuid]).listen((device) {
        // Change this string to what you defined in Zephyr
        if (device.name == "ESP32-xxxxxxxxxxxx") {
          _ubiqueDevice = device;
          foundDeviceWaitingToConnect = true;
          notifyListeners();
        }
      });
    }
  }

  void connectToDevice() {
    // We're done scanning, we can cancel it
    _scanStream.cancel();

    // Let's listen to our connection so we can make updates on a state change
    _currentConnectionStream = flutterReactiveBle.connectToDevice(id: _ubiqueDevice.id);
    _currentConnectionStream!.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: event.deviceId);
            flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic).listen((data) {
              print(utf8.decode(data));
            }, onError: (dynamic error) {
              // code to handle errors
            });

            foundDeviceWaitingToConnect = false;
            connected = true;
            notifyListeners();
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            break;
          }
        default:
      }
    });
  }

  Future sendWifiCredentials(String ssid, String password) async {
    if (connected) {
      await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic, value: utf8.encode("$ssid,$password"));
    }
  }
}
