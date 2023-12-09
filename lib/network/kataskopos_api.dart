import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_lazy_pot/dtos/lazypot_connection_dto.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';

class KataskoposApi {
  //final serverSocketAddress = 'http://192.168.178.11:45455/api/lazypot';
  final serverSocketAddress = 'http://kataskopos.nl/api/lazypot';

  Future<bool> connectLazyPotToPhone(String ssid, String password, String phoneId, String lazyPotId) async {
    var uri = Uri.parse('$serverSocketAddress/connectLazyPotToPhone/$ssid/$password/$phoneId/$lazyPotId');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    return response.body == "true";
  }

  Future<List<LazyPotDashboardThumbnailDTO>> GetLazyPotsByPhoneId(String phoneId) async {
    var uri = Uri.parse('$serverSocketAddress/getLazyPotsByPhoneId/$phoneId');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    final payloadList = <LazyPotDashboardThumbnailDTO>[];
    var reponse = json.decode(response.body);

    for (final serializedPayloadItem in reponse['response']) {
      payloadList.add(LazyPotDashboardThumbnailDTO.fromJson(serializedPayloadItem as Map<String, dynamic>));
    }

    return payloadList;
  }

  Future<LazyPotConnectionDTO> DeleteConnection(int connectionId) async {
    var uri = Uri.parse('$serverSocketAddress/deleteConnection/$connectionId');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    var jsonReponse = json.decode(response.body);
    var connection = LazyPotConnectionDTO.fromJson(jsonReponse['response']);

    return connection;
  }

  Future<LazyPotConnectionDTO> updateName(String name, int lazyPotId) async {
    var uri = Uri.parse('$serverSocketAddress/updateName/$lazyPotId/$name');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    var jsonReponse = json.decode(response.body);
    var connection = LazyPotConnectionDTO.fromJson(jsonReponse['response']);

    return connection;
  }

  Future<LazyPotConnectionDTO> updateWaterLevel(int waterLevel, int lazyPotId) async {
    var uri = Uri.parse('$serverSocketAddress/updateWaterLevel/$lazyPotId/$waterLevel');
    var response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    var jsonReponse = json.decode(response.body);
    var connection = LazyPotConnectionDTO.fromJson(jsonReponse['response']);

    return connection;
  }
}
