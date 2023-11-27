import 'package:flutter/material.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';
import '../network/kataskopos_api.dart';

class DashboardNotifier extends ChangeNotifier {
  final KataskoposApi _kataskoposApi;
  var phoneId = "3364e8b6-b422-45f1-93e4-a7e37257e1ae"; //const Uuid().v4();

  DashboardNotifier(this._kataskoposApi) {
    getLazyPots();
  }

  List<LazyPotDashboardThumbnailDTO> lazypots = <LazyPotDashboardThumbnailDTO>[];

  Future getLazyPots() async {
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
