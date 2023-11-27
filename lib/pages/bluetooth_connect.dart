import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class BluetoothConnect extends ConsumerWidget {
  const BluetoothConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bluetoothNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuring Lazypot..'),
        ),
        body: Container());
  }
}
