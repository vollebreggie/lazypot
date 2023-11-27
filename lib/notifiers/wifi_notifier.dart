import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:mobile_lazy_pot/network/kataskopos_api.dart';
import 'package:mobile_lazy_pot/network/lazy_pot_api.dart';
import 'package:mobile_lazy_pot/services/wifiservice.dart';
import 'package:uuid/uuid.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../pages/wifi_connect_lazypot_page.dart';
import 'dashboard_notifier.dart';

class WifiNotifier extends ChangeNotifier {
  final WifiService _wifiService;
  final LazyPotApi _lazyPotApi;
  final KataskoposApi _kataskoposApi;
  final DashboardNotifier _dashboardNotifier;

  bool loadingWifi = false;
  bool incorrectWifiPassword = false;
  bool searchLazyPot = false;
  bool goToWifiPage = false;
  bool lazyPotConnected = false;
  bool connectingLazyPot = false;

  StreamSubscription? wifiConnectedSubscription;
  StreamSubscription? connectivitySubscription;

  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];

  WifiNotifier(this._dashboardNotifier, this._wifiService, this._lazyPotApi, this._kataskoposApi);

  Future<void> startScan() async {
    // check if can-startScan
    var canStart = await WiFiScan.instance.canStartScan(askPermissions: true);

    // call startScan API
    await WiFiScan.instance.startScan();
    var results = await WiFiScan.instance.getScannedResults();
    var tempResult = List<WiFiAccessPoint>.from(results);
    tempResult.removeWhere((r) => r.ssid == "LazypotWifi");

    accessPoints = tempResult.distinct((a) => a.ssid).toList();
    notifyListeners();
  }

  void getScannedResults() async {
    // check platform support and necessary requirements
    final can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        // get scanned results
        final accessPoints = await WiFiScan.instance.getScannedResults();
        // ...
        break;
      // ... handle other cases of CanGetScannedResults values
    }

    var i = 0;
  }

  connectToLazyPotAP() async {
    try {
      searchLazyPot = true;
      notifyListeners();

      await _wifiService.connectToWifi();

      wifiConnectedSubscription = _wifiService.broadcastStream.listen((event) async {
        if (event) {
          wifiConnectedSubscription?.cancel();
          var response = await _lazyPotApi.ping();

          if (response == "pong") {
            connectingLazyPot = false;
            goToWifiPage = true;
            searchLazyPot = false;
            notifyListeners();
            //navigate to wifipage
            startScan();
          }
        } else {
          searchLazyPot = false;
          notifyListeners();
        }
      });
    } catch (ex) {
      print("##################");
      print(ex);

      lazyPotConnected = true;
      connectingLazyPot = false;
      searchLazyPot = false;
      notifyListeners();
      await _dashboardNotifier.getLazyPots();
    }
  }

  setIncorrectPassword(bool value) {
    incorrectWifiPassword = value;
    notifyListeners();
  }

  setLoadingWifid(bool value) {
    loadingWifi = value;
    notifyListeners();
  }

  test() async {
    await _lazyPotApi.sendMeasurementToServer();
    //await _kataskoposApi.connectLazyPotToPhone("test", "test", "phoneId", "lazyPotId");
  }

  void cancelConnection() {
    cancelWifiConnectedSubscription();
    cancelConnectivitySubscription();
    _wifiService.disconnectToWifi();
  }

  void cancelWifiConnectedSubscription() {
    wifiConnectedSubscription?.cancel();
  }

  void cancelConnectivitySubscription() {
    connectivitySubscription?.cancel();
  }

  sendCredentialsToLazyPot(String ssid, String password) async {
    try {
      loadingWifi = true;
      notifyListeners();

      var response = await _lazyPotApi.sendCredentials(ssid, password, _dashboardNotifier.phoneId);

      if (response) {
        connectingLazyPot = true;
        notifyListeners();

        await _lazyPotApi.setToSTA();

        connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
          if (result == ConnectivityResult.wifi) {
            connectivitySubscription?.cancel();
            // await _kataskoposApi.connectLazyPotToPhone(ssid, password, "testPhoneId", lazyPotId);
            // await _lazyPotApi.sendMeasurementToServer();
            lazyPotConnected = true;
            connectingLazyPot = false;
            searchLazyPot = false;
            notifyListeners();
            await _dashboardNotifier.getLazyPots();
          }
        });

        await _wifiService.disconnectToWifi();
      } else {
        loadingWifi = false;
        incorrectWifiPassword = true;
        notifyListeners();
      }
    } catch (ex) {
      print("##################");
      print(ex);

      lazyPotConnected = true;
      connectingLazyPot = false;
      searchLazyPot = false;
      notifyListeners();
      await _dashboardNotifier.getLazyPots();
    }
  }
}
