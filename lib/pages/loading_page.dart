import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/styles/color_pallet.dart';

import '../providers.dart';

class LoadingPage extends ConsumerWidget {
  LoadingPage({Key? key}) : super(key: key) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: ColorPallet.green,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.1,
                    left: width * 0.1,
                    child: Image(
                      image: const AssetImage('assets/smartphone_loading.png'),
                      width: width * 0.8,
                      height: height * 0.8,
                    ),
                  ),
                  Positioned(
                      top: height * 0.52,
                      left: width * 0.425,
                      child: Container(
                          height: height * 0.08,
                          width: width * 0.15,
                          child: const CircularProgressIndicator(
                            strokeWidth: 8,
                            color: ColorPallet.redGrey,
                          ))),
                  Positioned(
                      top: height * 0.8,
                      left: width * 0.35,
                      child: const Text("Please wait",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: ColorPallet.lightGrey,
                          ),
                          textAlign: TextAlign.center)),
                  Positioned(
                      top: height * 0.85,
                      left: width * 0.15,
                      child: const Text("Connecting lazyPot with phone..",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: ColorPallet.lightGrey,
                          ),
                          textAlign: TextAlign.center)),
                  Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Image(
                        image: const AssetImage('assets/bottom_green.png'),
                        width: width,
                        //height: 180,
                      ))
                ],
              )),
        ));
  }
}
