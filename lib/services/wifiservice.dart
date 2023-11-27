import 'package:flutter/services.dart';

class WifiService {
  final wifiMethodChannel = const MethodChannel('com.lazypot/wifi_service_method');
  final wifiEventChannel = const EventChannel('com.lazypot/wifi_service_event');
  late Stream<dynamic> broadcastStream;

  WifiService() {
    broadcastStream = wifiEventChannel.receiveBroadcastStream("listen");
    broadcastStream.listen((event) {
      print("Wifi Broadcast received: $event");
    });
  }

  Future<bool?> connectToWifi() async {
    return await wifiMethodChannel.invokeMethod<bool>('connect');
  }

  Future<bool?> disconnectToWifi() async {
    return await wifiMethodChannel.invokeMethod<bool>('disconnect');
  }
}
