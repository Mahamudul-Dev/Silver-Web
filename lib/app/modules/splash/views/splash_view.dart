import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ape_store/app/data/style.dart';

import '../../../data/asset_manager.dart';
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
      backgroundColor: AppColor.ACCENT_COLOR,
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage(AssetManager.SPLASH_LOGO),
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        
        Center(
          child: LoadingAnimationWidget.inkDrop(
              color: Colors.white, size: 30),
        ),
      ],
    ));
  }
}
