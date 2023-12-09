import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';
import '../providers.dart';
import '../styles/color_pallet.dart';
import '../styles/text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class LazyPotDetailPage extends StatelessWidget {
  final LazyPotDashboardThumbnailDTO thumbnail;
  LazyPotDetailPage({super.key, required this.thumbnail}) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: ColorPallet.green,
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  final FocusNode focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (_nameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(focusNode);
      _nameController.text = thumbnail.lazyPot.name;
      _nameController.selection = TextSelection.fromPosition(TextPosition(offset: _nameController.text.length));
    }

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 25.0,
          child: SizedBox(
            width: width,
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: InkWell(
                    child: const SizedBox(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                        systemNavigationBarColor: ColorPallet.green,
                        statusBarColor: ColorPallet.green,
                      ));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 35.0,
          right: 35,
          child: Consumer(builder: (context, ref, child) {
            return InkWell(
              child: const Image(
                image: AssetImage('assets/trash_red.png'),
                width: 35,
              ),
              onTap: () {
                final dashboardNotifier = ref.watch(dashboardNotifierProvider.notifier);
                dashboardNotifier.deleteConnection(thumbnail.lazyPot.id);
                Navigator.of(context).pop();
                dashboardNotifier.getLazyPots();
              },
            );
          }),
        ),
        Positioned(
            bottom: 0.0,
            left: 0,
            child: Image(
              image: const AssetImage('assets/detail_bottom.png'),
              width: width,
            )),
        Positioned(
          top: 100.0,
          left: 35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                child: Row(children: [
                  const SizedBox(
                    height: 50,
                    child: Icon(color: ColorPallet.green, Icons.edit, size: 20),
                  ),
                  Consumer(builder: (context, ref, child) {
                    var notifier = ref.watch(dashboardDetailNotifierProvider.notifier);
                    focusNode.removeListener(() => updateName(_nameController.text, thumbnail.lazyPot.id, ref));
                    focusNode.addListener(() => updateName(_nameController.text, thumbnail.lazyPot.id, ref));

                    return Container(
                      height: 50,
                      width: width * 0.8,
                      margin: const EdgeInsets.only(left: 5),
                      child: TextField(
                        focusNode: focusNode,
                        style: textStyleSoho14Darkgrey,
                        controller: _nameController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Lazypot name',
                        ),
                      ),
                    );
                  }),
                ]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/wifi_4.png'),
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      thumbnail.lazyPot.ssid,
                      style: textStyleSoho10Darkgrey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/soil_fancy.png'),
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${thumbnail.lastMeasurement.moistureLevelMeasure}%",
                      style: textStyleSoho10Darkgrey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/water_fancy.png'),
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${thumbnail.lastMeasurement.waterLevelMeasure}%",
                      style: textStyleSoho10Darkgrey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/battery_fancy.png'),
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${thumbnail.lastMeasurement.batteryLevel}%",
                      style: textStyleSoho10Darkgrey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(color: Colors.brown, Icons.sync, size: 25),
                    const SizedBox(width: 5),
                    Text(
                      timeUntil(thumbnail.lastMeasurement.created),
                      style: textStyleSoho10Darkgrey,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          top: height * 0.46,
          left: 10,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Waterlevel",
              style: textStyleSoho14Darkgrey,
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Consumer(builder: (context, ref, child) {
                  final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider);
                  var waterLevel = dashboardDetailNotifier.waterLevelTest == -1 ? thumbnail.lazyPot.waterLevelMode : dashboardDetailNotifier.waterLevelTest;

                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: waterLevel != 0 ? Colors.white : Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Color.fromARGB(255, 143, 140, 140), offset: Offset(1, 3))]),
                      width: width * 0.30,
                      height: height * 0.15,
                      child: Column(children: [
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: width * 0.2,
                          height: height * 0.1,
                          child: const Image(
                            image: AssetImage('assets/desert.png'),
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Desert",
                          style: textStyleSoho14Darkgrey,
                        )
                      ]),
                    ),
                    onTap: () {
                      final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider.notifier);
                      dashboardDetailNotifier.updateWaterLevel(0, thumbnail.lazyPot.id);
                    },
                  );
                }),
                SizedBox(width: width * 0.03),
                Consumer(builder: (context, ref, child) {
                  final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider);
                  var waterLevel = dashboardDetailNotifier.waterLevelTest == -1 ? thumbnail.lazyPot.waterLevelMode : dashboardDetailNotifier.waterLevelTest;
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: waterLevel != 1 ? Colors.white : Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Color.fromARGB(255, 143, 140, 140), offset: Offset(1, 3))]),
                      width: width * 0.30,
                      height: height * 0.15,
                      child: Column(children: [
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: width * 0.2,
                          height: height * 0.1,
                          child: const Image(
                            image: AssetImage('assets/normal.png'),
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Normal",
                          style: textStyleSoho14Darkgrey,
                        )
                      ]),
                    ),
                    onTap: () {
                      final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider.notifier);
                      dashboardDetailNotifier.updateWaterLevel(1, thumbnail.lazyPot.id);
                    },
                  );
                }),
                SizedBox(width: width * 0.03),
                Consumer(builder: (context, ref, child) {
                  final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider);
                  var waterLevel = dashboardDetailNotifier.waterLevelTest == -1 ? thumbnail.lazyPot.waterLevelMode : dashboardDetailNotifier.waterLevelTest;
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: waterLevel != 2 ? Colors.white : Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Color.fromARGB(255, 143, 140, 140), offset: Offset(1, 3))]),
                      width: width * 0.30,
                      height: height * 0.15,
                      child: Column(children: [
                        SizedBox(height: height * 0.01),
                        SizedBox(
                          width: width * 0.2,
                          height: height * 0.1,
                          child: const Image(
                            image: AssetImage('assets/tropical.png'),
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          "Tropical",
                          style: textStyleSoho14Darkgrey,
                        )
                      ]),
                    ),
                    onTap: () {
                      final dashboardDetailNotifier = ref.watch(dashboardDetailNotifierProvider.notifier);
                      dashboardDetailNotifier.updateWaterLevel(2, thumbnail.lazyPot.id);
                    },
                  );
                })
              ],
            )
          ]),
        ),
      ]),
    ));
  }

  void updateName(String name, int lazyPotId, WidgetRef ref) {
    if (!focusNode.hasFocus) {
      final notifer = ref.read(dashboardDetailNotifierProvider.notifier);
      notifer.updateName(name, lazyPotId);
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: 'nl', allowFromNow: true);
  }

  Widget getBatteryImage(double level) {
    if (level >= -80) {
      return const Image(
        image: AssetImage('assets/battery_fancy_4.png'),
        width: 20,
        height: 20,
      );
    } else if (level <= 80 && level >= 60) {
      return const Image(
        image: AssetImage('assets/battery_fancy_3.png'),
        width: 20,
        height: 20,
      );
    } else if (level <= 60 && level >= 40) {
      return const Image(
        image: AssetImage('assets/battery_fancy_2.png'),
        width: 20,
        height: 20,
      );
    } else if (level <= 40 && level >= 20) {
      return const Image(
        image: AssetImage('assets/battery_fancy_1.png'),
        width: 20,
        height: 20,
      );
    } else {
      return const Image(
        image: AssetImage('assets/battery_fancy_0.png'),
        width: 20,
        height: 20,
      );
    }
  }
}
