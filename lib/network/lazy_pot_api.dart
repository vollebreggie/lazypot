import 'dart:convert';

import 'package:http/http.dart' as http;

class LazyPotApi {
  final lazyPotSocketAddress = 'http://192.168.1.1:80';

  Future<String> ping() async {
    var uri = Uri.parse('$lazyPotSocketAddress/ping');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    return response.body;
  }

  Future setToAP() async {
    var uri = Uri.parse('$lazyPotSocketAddress/wifiAP');
    await http.get(uri, headers: {'Content-Type': 'application/json'});
  }

  Future sendMeasurementToServer() async {
    var uri = Uri.parse('$lazyPotSocketAddress/sendMeasurement');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    print(response);
  }

  Future setToSTA() async {
    var uri = Uri.parse('$lazyPotSocketAddress/wifiSTA');
    await http.get(uri, headers: {'Content-Type': 'application/json'});
  }

  Future<bool> sendCredentials(String ssid, String password, String phoneId) async {
    var uri = Uri.parse('$lazyPotSocketAddress/updateCredentials');
    var body = jsonEncode(<String, String>{'ssid': ssid, 'password': password, 'phoneId': phoneId});

    var response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);

    return response.body == "true";
  }
}
