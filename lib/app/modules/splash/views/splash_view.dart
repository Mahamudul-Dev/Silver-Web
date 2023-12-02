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
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.HOME);
    });
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage('assets/appstore.png'),
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
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
