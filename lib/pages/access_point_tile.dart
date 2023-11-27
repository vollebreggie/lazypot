import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/providers.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../styles/color_pallet.dart';
import '../styles/text_style.dart';

class AccessPointTile extends ConsumerWidget {
  final WiFiAccessPoint accessPoint;
  final TextEditingController _passwordController = TextEditingController();

  AccessPointTile({Key? key, required this.accessPoint}) : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    title = title.length > 15 ? '${title.substring(0, 13)}..' : title;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 35, right: 35, bottom: 25),
        child: Row(children: [
          Container(
            width: width * 0.6,
            height: height * 0.1,
            decoration: BoxDecoration(border: Border.all(color: ColorPallet.darkGreen)),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: getWifiImage(accessPoint.level),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: Text(
                      title,
                      style: textStyleRobotoWifi,
                    ))
              ],
            ),
          ),
          Container(
            width: width * 0.2,
            height: height * 0.1,
            decoration: const BoxDecoration(
              color: ColorPallet.darkGreen,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(
                image: AssetImage('assets/connect_white.png'),
                width: 30,
                height: 30,
              ),
            ]),
          ),
        ]),
      ),
      onTap: () {
        final notifier = ref.watch(wifiNotifierProvider.notifier);
        notifier.setIncorrectPassword(false);
        notifier.setLoadingWifid(false);
        showWifiCredentialsDialog(context, title);
      },
    );
  }

  Widget getWifiImage(int level) {
    if (level >= -80) {
      return const Image(
        image: AssetImage('assets/wifi_4.png'),
        width: 50,
        height: 50,
      );
    } else if (level <= -80 && level >= -100) {
      return const Image(
        image: AssetImage('assets/wifi_3.png'),
        width: 50,
        height: 50,
      );
    } else if (level <= -100 && level >= -80) {
      return const Image(
        image: AssetImage('assets/wifi_2.png'),
        width: 50,
        height: 50,
      );
    } else {
      return const Image(
        image: AssetImage('assets/wifi.png'),
        width: 50,
        height: 50,
      );
    }
  }

  Future<dynamic> showWifiCredentialsDialog(BuildContext context, String title) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Connect wifi to lazypot', style: TextStyle(fontSize: 18.0, color: ColorPallet.darkGreenTransparent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              child: TextField(
                style: const TextStyle(
                  fontSize: 17.0,
                  color: ColorPallet.darkGreenTransparent,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: ColorPallet.green)), enabled: false),
                controller: TextEditingController(text: title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              child: TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: ColorPallet.green)),
                  hintText: 'Wifi password',
                ),
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final wifiNotifier = ref.watch(wifiNotifierProvider.notifier);
              final state = ref.watch(wifiNotifierProvider);
              if (state.incorrectWifiPassword) {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text("Incorrect password",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ColorPallet.red,
                        fontWeight: FontWeight.w600,
                      )),
                );
              }
              return Container();
            })
          ],
        ),
        actions: <Widget>[
          Consumer(builder: (context, ref, child) {
            final state = ref.watch(wifiNotifierProvider);
            if (!state.loadingWifi) {
              return TextButton(
                child: const Text('Cancel', style: TextStyle(fontSize: 15.0, color: ColorPallet.lightGrey)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            }
            return Container();
          }),
          Consumer(
            builder: (context, ref, child) {
              final wifiNotifier = ref.watch(wifiNotifierProvider.notifier);
              final state = ref.watch(wifiNotifierProvider);

              if (state.loadingWifi) {
                return Container(
                  margin: const EdgeInsets.only(right: 40, left: 10, bottom: 20),
                  height: 25,
                  width: 25,
                  child: const CircularProgressIndicator(
                    strokeWidth: 5,
                    color: ColorPallet.redGrey,
                  ),
                );
              } else {
                return TextButton(
                  child: const Text('Connect',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ColorPallet.green,
                        fontWeight: FontWeight.w600,
                      )),
                  onPressed: () {
                    wifiNotifier.sendCredentialsToLazyPot(title, _passwordController.text);
                  },
                ); // Hello world
              }
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> showDetailsDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfo("BSSDI", accessPoint.bssid),
            _buildInfo("Capability", accessPoint.capabilities),
            _buildInfo("frequency", "${accessPoint.frequency}MHz"),
            _buildInfo("level", accessPoint.level),
            _buildInfo("standard", accessPoint.standard),
            _buildInfo("centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
            _buildInfo("centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
            _buildInfo("channelWidth", accessPoint.channelWidth),
            _buildInfo("isPasspoint", accessPoint.isPasspoint),
            _buildInfo("operatorFriendlyName", accessPoint.operatorFriendlyName),
            _buildInfo("venueName", accessPoint.venueName),
            _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
          ],
        ),
      ),
    );
  }
}
