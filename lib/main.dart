import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app/data/config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(AppConfig.IS_FULL_SCREEN){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  if (AppConfig.IS_ONSIGNAL_ENABLED) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(AppConfig.ONESIGNAL_APP_ID);
    OneSignal.Notifications.requestPermission(true);
  }

  if(AppConfig.ENABLE_FIREBASE){
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  }

  runApp(
    GetMaterialApp(
      title: AppConfig.APP_NAME,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
