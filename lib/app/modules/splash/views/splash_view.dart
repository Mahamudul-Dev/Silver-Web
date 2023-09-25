import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:silver_view/app/data/style.dart';

import '../../../routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(Routes.HOME);
    });
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: const Image(
              image: AssetImage('assets/afrister-banner.png'),
              fit: BoxFit.cover),
        ),
        const Expanded(
            child: Image(
          image: AssetImage('assets/logo-splash.png'),
          fit: BoxFit.cover,
        )),
        Container(
          color: Colors.white,
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: LoadingAnimationWidget.inkDrop(
                color: AppColor.ACCENT_COLOR, size: 30),
          ),
        ),
        Container(
          height: 50,
          color: Colors.white,
        )
      ],
    ));
  }
}
