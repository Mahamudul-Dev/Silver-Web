import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ape_store/app/data/asset_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/style.dart';
import '../../../data/config.dart';
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
                      settings: PullToRefreshSettings(
                        color: AppColor.ACCENT_COLOR,
                      ),
                    ),
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      final uri = navigationAction.request.url;
                      if (uri != null &&
                          AppConfig.BLOCKED_SCHEME.contains(uri.scheme)) {
                        try {
                          final canLaunch = await canLaunchUrl(uri);
                          print(canLaunch);
                          // if(canLaunch){
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                          // }
                        } catch (e) {
                          print(e);
                        }
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    initialUrlRequest: URLRequest(
                      url: WebUri(
                          AppConfig.URL), // Replace with your desired URL
                    ),
                    onGeolocationPermissionsShowPrompt:
                        (controller, origin) async {
                      return GeolocationPermissionShowPromptResponse(
                        allow: true, // Grant location permission
                        retain: true,
                        origin: origin, // Keep it granted across reloads
                      );
                    },
                    initialSettings: InAppWebViewSettings(
                      supportZoom: false,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      cacheEnabled: true,
                      geolocationEnabled: true,
                      allowContentAccess: true,
                      allowsLinkPreview: true,
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                      useOnDownloadStart: true,
                      userAgent:
                          "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
                      verticalScrollBarEnabled: false,
                      horizontalScrollBarEnabled: false,
                      transparentBackground: true,
                      useHybridComposition: true,
                      thirdPartyCookiesEnabled: true,
                      allowFileAccess: true,
                      allowsInlineMediaPlayback: true,
                    ),
                    onLoadStart: (webController, url) {
                      if (!controller.isLoading.value) {
                        controller.isLoading.value = true;
                      }
                      print({
                        "Scheme": url?.scheme,
                        "Host": url?.host,
                        "Path": url?.path
                      });
                    },
                    onReceivedError: (webController, request, error) {
                      print(error);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            actions: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.ACCENT_COLOR)),
                                  onPressed: () {
                                    controller.reload();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Retry"))
                            ],
                          );
                        },
                      );
                    },
                    onReceivedHttpError: (webController, request, error) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            actions: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppColor.ACCENT_COLOR)),
                                  onPressed: () {
                                    controller.reload();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Retry"))
                            ],
                          );
                        },
                      );
                    },
                    onWebViewCreated: (newWebviewController) {
                      controller.webViewController = newWebviewController;
                      if (!controller.isLoading.value) {
                        controller.isLoading.value = true;
                      }
                    },
                    onProgressChanged: (webviewController, progress) {
                      debugPrint("progress: ${progress.toString()}");
                      controller.webViewProgress.value = progress;
                    },
                    onLoadStop: (webviewController, url) async {
                      controller.currentLoadedUri.value = url;

                      controller.isLoading.value = false;
                    },
                  ),
                  controller.isLoading.value
                      ? Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.height * 0.12,
                            child: Card(
                              color: AppColor.ACCENT_COLOR.withAlpha(70),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
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
      backgroundColor: AppColor.ACCENT_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(40.0), // Adjust the radius as needed
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          DotLottieLoader.fromAsset(AssetManager.NO_INTERNET_ANIM,
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
