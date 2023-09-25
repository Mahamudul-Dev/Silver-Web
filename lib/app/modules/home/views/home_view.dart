import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../data/utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    controller.webViewController?.loadUrl(
        urlRequest: URLRequest(
      url: controller.currentLoadedUri.value, // Replace with your desired URL
    ));
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
          body: Obx(() => controller.isConnected.value
              ? InAppWebView(
                  pullToRefreshController: PullToRefreshController(
                      onRefresh: onRefresh,
                      options: PullToRefreshOptions(
                        color: Colors.green,
                      )),
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
                  onProgressChanged: (webviewController, progress) {
                    controller.webViewProgress.value = progress;
                  },
                  onLoadStop: (webviewController, url) {
                    controller.currentLoadedUri.value = url;
                  },
                )
              : AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        40.0), // Adjust the radius as needed
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/wifi_animation.json'),
                      const Text(
                        'No Internet, Please check the connection!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ))),
    );
  }
}
