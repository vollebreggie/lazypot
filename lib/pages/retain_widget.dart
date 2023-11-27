import 'package:flutter/material.dart';

class RetainWidget extends StatelessWidget {
  const RetainWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: child);
  }
}
