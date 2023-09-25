import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width.obs;
    Future.delayed(const Duration(seconds: 5), () {
      // Replace the next line with the appropriate route for your app
      Get.offNamed(Routes.HOME);
    });
    return Scaffold(
        body: Center(
            child: Obx(() => Image.asset(
                  width.value > 550
                      ? 'assets/large_splash_bg.png'
                      : 'assets/splash_bg.png',
                  fit: BoxFit.cover,
                ))));
  }
}
