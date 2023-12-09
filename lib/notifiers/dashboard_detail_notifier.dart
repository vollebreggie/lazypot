import 'package:flutter/material.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';
import '../network/kataskopos_api.dart';
import 'dashboard_notifier.dart';

class DashboardDetailNotifier extends ChangeNotifier {
  final KataskoposApi _kataskoposApi;
  final DashboardNotifier _dashboardNotifier;

  int waterLevelTest = -1;

  DashboardDetailNotifier(this._kataskoposApi, this._dashboardNotifier);

  Future updateName(String name, int lazyPotId) async {
    await _kataskoposApi.updateName(name, lazyPotId);
    _dashboardNotifier.getLazyPots();
  }

  Future updateWaterLevel(int waterLevel, int lazyPotId) async {
    waterLevelTest = waterLevel;
    notifyListeners();

    await _kataskoposApi.updateWaterLevel(waterLevel, lazyPotId);
    _dashboardNotifier.getLazyPots();
  }
}
