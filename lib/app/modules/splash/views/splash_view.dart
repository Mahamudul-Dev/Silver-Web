import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 5), () {
    //   // Replace the next line with the appropriate route for your app
    //   Get.offNamed(Routes.HOME);
    // });
    return const Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Image(
                image: AssetImage('assets/afrister-banner.png'),
                fit: BoxFit.cover)),
        Expanded(
            child: Image(
          image: AssetImage('assets/logo-splash.png'),
          fit: BoxFit.cover,
        ))
      ],
    ));
  }
}
