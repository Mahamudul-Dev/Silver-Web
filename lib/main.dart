import 'package:flutter/services.dart';

import 'app/data/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(
    GetMaterialApp(
      title: APP_NAME,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
