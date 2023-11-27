import 'package:flutter/material.dart';

import '../network/kataskopos_api.dart';
import 'dashboard_notifier.dart';

class DashboardDetailNotifier extends ChangeNotifier {
  final KataskoposApi _kataskoposApi;
  final DashboardNotifier _dashboardNotifier;

  DashboardDetailNotifier(this._kataskoposApi, this._dashboardNotifier);

  Future updateName(String name, int lazyPotId) async {
    await _kataskoposApi.updateName(name, lazyPotId);
    _dashboardNotifier.getLazyPots();
  }
}
