import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/style.dart';
import '../../../data/utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    return await Future.delayed(Duration(seconds: 2));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.webViewController != null) {
          if (await controller.webViewController!.canGoBack()) {
            controller.webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: LiquidPullToRefresh(
        onRefresh: onRefresh,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(URL), // Replace with your desired URL
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              // Configure WebView options here
            ),
          ),
          onWebViewCreated: (newWebviewController) {
            controller.webViewController = newWebviewController;
          },
        ),
      
      //   WebviewScaffold(
      //     url: URL,
      //     initialChild: Container(
      //   color: Colors.white,
      //   child: Center(
      //     child: LoadingAnimationWidget.fallingDot(color: AppColor.ACCENT_COLOR, size: 40),
      //   ),
      // ),
      //   ),
      ),
      ),
    );
  }
}
