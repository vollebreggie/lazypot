import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/styles/color_pallet.dart';

import '../dtos/lazypot_dashboard_thumbnail_dto.dart';
import '../providers.dart';
import '../styles/text_style.dart';
import 'dashboard_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'lazypot_detail_page.dart';

class DashboardThumbnail extends StatelessWidget {
  final LazyPotDashboardThumbnailDTO thumbnail;
  final WidgetRef ref;
  const DashboardThumbnail({super.key, required this.thumbnail, required this.ref});

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 15.0, top: 10),
        margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 3,
              blurRadius: 15,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(
              thumbnail.lazyPot.name,
              style: textStyleRoboto16Darkgrey,
            ),
            const Spacer(),
            Container(
                margin: const EdgeInsets.only(right: 15, top: 5, left: 5, bottom: 5),
                child: InkWell(
                  onTap: () {
                    final dashboardNotifier = ref.watch(dashboardNotifierProvider.notifier);
                    dashboardNotifier.deleteConnection(thumbnail.lazyPot.id);
                  },
                  child: const Image(
                    image: AssetImage('assets/trash_red.png'),
                    width: 20,
                  ),
                ))
          ]),
          Container(
            padding: const EdgeInsets.only(left: 7.0, top: 10),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(children: [
                const Image(
                  image: AssetImage('assets/soil_fancy.png'),
                  width: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "${thumbnail.lastMeasurement.moistureLevelMeasure.round()}%",
                  style: textStyleSoho10Darkgrey,
                )
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Image(
                  image: AssetImage('assets/water_fancy.png'),
                  width: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "${thumbnail.lastMeasurement.waterLevelMeasure.round()}%",
                  style: textStyleSoho10Darkgrey,
                )
              ]),
              const SizedBox(height: 10),
              Row(children: [
                getBatteryImage(thumbnail.lastMeasurement.batteryLevel),
                const SizedBox(width: 10),
                Text(
                  "${thumbnail.lastMeasurement.batteryLevel.round()}%",
                  style: textStyleSoho10Darkgrey,
                )
              ])
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15.0, top: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(padding: const EdgeInsets.only(top: 5), child: Text(timeUntil(thumbnail.lastMeasurement.created), style: textStyleRoboto8Lightgrey)),
              const SizedBox(width: 3),
              const Icon(color: ColorPallet.green, Icons.sync, size: 20),
            ]),
          )
        ]),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LazyPotDetailPage(
                    thumbnail: thumbnail,
                  )),
        );
      },
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: locale, allowFromNow: true);
  }

  Widget getBatteryImage(double level) {
    if (level >= 80) {
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
