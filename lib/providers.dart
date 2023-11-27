import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/network/kataskopos_api.dart';
import 'package:mobile_lazy_pot/notifiers/dashboard_notifier.dart';
import 'package:mobile_lazy_pot/services/wifiservice.dart';
import 'package:riverpod/riverpod.dart';

import 'network/lazy_pot_api.dart';
import 'notifiers/bluetooth_notifier.dart';
import 'notifiers/dashboard_detail_notifier.dart';
import 'notifiers/wifi_notifier.dart';

//Notifiers
final bluetoothNotifierProvider = ChangeNotifierProvider(
  (ref) => BluetoothNotifier(),
);

final wifiNotifierProvider = ChangeNotifierProvider(
  (ref) => WifiNotifier(ref.read(dashboardNotifierProvider), ref.read(wifiServiceProvider), ref.read(lazyPotApiProvider), ref.read(kataskoposApiProvider)),
);

final dashboardNotifierProvider = ChangeNotifierProvider(
  (ref) => DashboardNotifier(ref.read(kataskoposApiProvider)),
);

final dashboardDetailNotifierProvider = ChangeNotifierProvider(
  (ref) => DashboardDetailNotifier(ref.read(kataskoposApiProvider), ref.read(dashboardNotifierProvider)),
);

//Services
final wifiServiceProvider = Provider<WifiService>((ref) => WifiService());

//Api
final lazyPotApiProvider = Provider<LazyPotApi>((ref) => LazyPotApi());
final kataskoposApiProvider = Provider<KataskoposApi>((ref) => KataskoposApi());
