import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_lazy_pot/pages/dashboard_page.dart';
import 'package:mobile_lazy_pot/pages/loading_page.dart';
import 'package:mobile_lazy_pot/pages/navigation_widget.dart';
import 'package:mobile_lazy_pot/pages/retain_widget.dart';

void main() {
  return runApp(
    ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationPage(
        child: DashboardPage(),
      ),
    )),
  );
}
