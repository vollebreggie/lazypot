import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/pages/access_point_tile.dart';
import 'package:mobile_lazy_pot/providers.dart';

import '../styles/color_pallet.dart';

class WifiConnectLazyPotPage extends ConsumerWidget {
  const WifiConnectLazyPotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiState = ref.watch(wifiNotifierProvider);
    final wifiNotifier = ref.watch(wifiNotifierProvider.notifier);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              systemNavigationBarColor: ColorPallet.green,
              statusBarColor: ColorPallet.green,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light));

          wifiNotifier.cancelConnection();
          return Future(() => true);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(children: [
              Stack(children: [
                Positioned(
                  top: height * 0.1,
                  left: width * 0.1,
                  child: Image(
                    image: const AssetImage('assets/home_wifi_transparant.png'),
                    width: width * 0.8,
                    height: height * 0.8,
                  ),
                ),
                SizedBox(
                  height: height * 0.9,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 125),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wifiState.accessPoints.length,
                    itemBuilder: (context, i) => AccessPointTile(accessPoint: wifiState.accessPoints[i]),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 40,
                  child: InkWell(
                    child: const Image(
                      image: AssetImage('assets/cancel_red.png'),
                      width: 50,
                      height: 50,
                    ),
                    onTap: () {
                      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                          systemNavigationBarColor: ColorPallet.green,
                          statusBarColor: ColorPallet.green,
                          statusBarIconBrightness: Brightness.light,
                          systemNavigationBarIconBrightness: Brightness.light));

                      wifiNotifier.cancelConnection();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ]),
            ]),
          ),
        ));
  }
}
