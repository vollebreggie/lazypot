import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/pages/access_point_tile.dart';

import '../providers.dart';

class WifiTestPage extends ConsumerWidget {
  const WifiTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiState = ref.watch(wifiNotifierProvider);
    final wifiNotifier = ref.watch(wifiNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: wifiState.accessPoints.length,
        itemBuilder: (context, i) => AccessPointTile(accessPoint: wifiState.accessPoints[i]),
      ),
      persistentFooterButtons: [
        // wifiState.connectToLazyPot
        //     // True condition
        //     ? ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.grey, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.search),
        //       )
        //     // False condition
        //     : ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.blue, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.search),
        //       ),
        // wifiState.scan
        //     // True condition
        //     ? ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.blue, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: wifiNotifier.startScan,
        //         child: const Icon(Icons.wifi),
        //       )
        //     // False condition
        //     : ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.grey, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.wifi),
        //       ),
        // wifiState.connected
        //     // True condition
        //     ? ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.blue, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.check),
        //       )
        //     // False condition
        //     : ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.grey, // background
        //           foregroundColor: Colors.white, // foreground
        //         ),
        //         onPressed: () {},
        //         child: const Icon(Icons.check),
        //       ),
      ],
    );
  }
}
