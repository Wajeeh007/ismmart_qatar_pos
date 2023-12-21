import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ismmart_dubai_pos/screens/home/home_view.dart';
import 'package:ismmart_dubai_pos/screens/login/login_view.dart';
import 'package:ismmart_dubai_pos/screens/order_history/order_history_view.dart';
import 'package:ismmart_dubai_pos/screens/order_history_detail/order_history_detail_view.dart';
import 'package:window_manager/window_manager.dart';

import 'helper/theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1000, 500),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  HttpOverrides.global = MyHttpOverrides();

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISMMART POS',
      theme: ThemeData(
        primarySwatch: ThemeHelper.platte1,
        scaffoldBackgroundColor: ThemeHelper.backgroundColor,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: ThemeHelper.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => HomeView(),
        '/order_details': (context) => OrderHistoryView(),
        '/order-history-detail': (context) => OrderDetailScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
