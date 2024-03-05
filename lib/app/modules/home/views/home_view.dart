import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../data/style.dart';
import '../../../data/utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      // internetConnectionState.add(result);
      HomeController.isConnected.value = result != ConnectivityResult.none;
    });
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
        body: Obx(() {
          if (HomeController.isConnected.value) {
            return SafeArea(
              child: Stack(
                children: [
                  InAppWebView(
                    pullToRefreshController: PullToRefreshController(
                        onRefresh: controller.onRefresh,
                        options: PullToRefreshOptions(
                          color: AppColor.ACCENT_COLOR,
                        )),
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(URL), // Replace with your desired URL
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        // Configure WebView options here
                        supportZoom: false,
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                      ),
                    ),
                    onLoadStart: (webController, url) {
                      if(!controller.isLoading.value){
                        controller.isLoading.value = true;
                      }
                      debugPrint("Load start");
                    },
                    onLoadError: (controller, url, code, message) {},
                    onLoadHttpError:
                        (controller, url, statusCode, description) {},
                    onWebViewCreated: (newWebviewController) {
                      controller.webViewController = newWebviewController;
                      if(!controller.isLoading.value){
                        controller.isLoading.value = true;
                      }
                    },
                    onProgressChanged: (webviewController, progress) {
                      debugPrint("progress: ${progress.toString()}");
                      controller.webViewProgress.value = progress;
                    },
                    onLoadStop: (webviewController, url) async {
                      controller.currentLoadedUri.value = url;
                      await webviewController.evaluateJavascript(
                        source:
                            "var footers = document.getElementsByClassName('site-footer'); for (var i = 0; i < footers.length; i++) {   footers[i].style.display = 'none'; }",
                      );
                      controller.isLoading.value = false;
                    },
                  ),
                  controller.isLoading.value
                      ? Align(
                    alignment: Alignment.center,
                        child: SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.height * 0.12,
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.ACCENT_COLOR,
                                    // value: controller.webViewProgress.value / 100,
                                  ),
                                ),
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink()
                ],
              ),
            );
          } else {
            return _buildNoInteretView();
          }
        }),

        // floatingActionButton:  Obx(() => HomeController.isConnected.value ? FloatingActionButton(onPressed: ()=> controller.goHome(), backgroundColor: AppColor.ACCENT_COLOR, child: const Icon(Icons.home, color: Colors.white,),) : const SizedBox.shrink())
      ),
    );
  }

  Widget _buildNoInteretView() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(40.0), // Adjust the radius as needed
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          DotLottieLoader.fromAsset("assets/no_internet_animation.lottie",
              frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
            if (dotlottie != null) {
              return Lottie.memory(dotlottie.animations.values.single);
            } else {
              return Container();
            }
          }),
          const Text(
            'No Internet, Please check the connection!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }
}
