import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';
import '../network/kataskopos_api.dart';

class DashboardNotifier extends ChangeNotifier {
  final KataskoposApi _kataskoposApi;
  SharedPreferences? prefs;
  var phoneId = ""; //const Uuid().v4();

  DashboardNotifier(this._kataskoposApi) {
    getLazyPots();
  }

  List<LazyPotDashboardThumbnailDTO> lazypots = <LazyPotDashboardThumbnailDTO>[];

  Future configSharedPreferences() async {
    if (phoneId.isEmpty) {
      prefs = await SharedPreferences.getInstance();
      prefs!.setString("phoneId", "3364e8b6-b422-45f1-93e4-a7e37257e1ae");
      phoneId = prefs!.getString("phoneId")!;
    }
  }

  Future getLazyPots() async {
    await configSharedPreferences();
    lazypots = await _kataskoposApi.GetLazyPotsByPhoneId(phoneId);
    notifyListeners();
  }

  Future deleteConnection(int connectionId) async {
    await _kataskoposApi.DeleteConnection(connectionId);
    await getLazyPots();
  }

  String getPhoneId() {
    return phoneId;
  }
}
