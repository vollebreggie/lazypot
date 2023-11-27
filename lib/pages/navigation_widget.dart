import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/pages/dashboard_page.dart';
import 'package:mobile_lazy_pot/pages/loading_page.dart';
import 'package:mobile_lazy_pot/pages/wifi_connect_lazypot_page.dart';

import '../providers.dart';
import '../styles/color_pallet.dart';

class NavigationPage extends ConsumerWidget {
  final Widget child;

  const NavigationPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wifiNotifierProvider);
    final notifier = ref.watch(wifiNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.goToWifiPage) {
        notifier.goToWifiPage = false;

        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WifiConnectLazyPotPage()),
        );
      }

      if (state.lazyPotConnected) {
        notifier.lazyPotConnected = false;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPallet.green,
            statusBarColor: ColorPallet.green,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }

      if (state.connectingLazyPot) {
        notifier.connectingLazyPot = false;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPallet.green,
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.light));
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingPage()));
      }
    });

    return child;
  }
}
