import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/providers.dart';

import '../styles/color_pallet.dart';
import '../styles/responsive_ui.dart';
import '../styles/text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'dashboard_thumbnail.dart';

var locale = 'nl';

class DashboardPage extends ConsumerWidget {
  DashboardPage({Key? key}) : super(key: key) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: ColorPallet.green,
        statusBarColor: ColorPallet.green,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiNotifier = ref.watch(wifiNotifierProvider.notifier);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    initialiseResponsiveUI(context);

    timeago.setLocaleMessages('nl_short', timeago.NlShortMessages());
    timeago.setLocaleMessages('nl', timeago.NlMessages());

    return WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: () => refreshLazyPots(ref),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Image(
                      image: const AssetImage('assets/header_green.png'),
                      width: width,
                      height: 180,
                    ),
                  ),
                  Positioned(
                    top: 125,
                    right: 75,
                    child: Text(
                      "LazyPots",
                      style: textStyleRobotoHeader,
                    ),
                  ),
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              margin: const EdgeInsets.only(left: 30),
                              child: const Image(
                                image: AssetImage('assets/add_pot_black_transparant.png'),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            top: height * 0.4,
                            left: width * 0.27,
                            child: Container(
                              margin: const EdgeInsets.only(top: 100),
                              child: const Image(
                                image: AssetImage('assets/right_arrow_transparant.png'),
                                width: 50,
                              ),
                            ),
                          ),
                          Align(
                              alignment: AlignmentDirectional.center,
                              child: Container(
                                margin: const EdgeInsets.only(left: 30),
                                child: const Image(
                                  image: AssetImage('assets/home_wifi_transparant.png'),
                                  width: 100,
                                  height: 100,
                                ),
                              )),
                          Positioned(
                            top: height * 0.4,
                            right: width * 0.27,
                            child: Container(
                              margin: const EdgeInsets.only(top: 100),
                              child: const Image(
                                image: AssetImage('assets/right_arrow_transparant.png'),
                                width: 50,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: const Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Image(
                                image: AssetImage('assets/smartphone_check_transparant.png'),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          )
                        ],
                      )),
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.20),
                      child: Consumer(builder: (context, ref, child) {
                        var state = ref.watch(dashboardNotifierProvider);
                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10.0),
                          children: List.generate(state.lazypots.length, (i) {
                            return DashboardThumbnail(
                              thumbnail: state.lazypots[i],
                              ref: ref,
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                  Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Image(
                        image: const AssetImage('assets/bottom_green.png'),
                        width: width,
                      ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 5,
              onPressed: () {
                //wifiNotifier.test();
                //wifiNotifier.getScannedResults();
                wifiNotifier.connectToLazyPotAP();
              },
              backgroundColor: ColorPallet.darkGreen,
              child: Consumer(builder: (context, ref, child) {
                var state = ref.watch(wifiNotifierProvider);

                if (state.searchLazyPot) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  return const Image(
                    image: AssetImage('assets/add_pot_white.png'),
                    width: 35,
                    height: 35,
                  );
                }
              }),
            )));
  }

  Future<void> refreshLazyPots(WidgetRef ref) async {
    final dashboardNotifier = ref.read(dashboardNotifierProvider.notifier);
    dashboardNotifier.getLazyPots();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: locale, allowFromNow: true);
  }
}
