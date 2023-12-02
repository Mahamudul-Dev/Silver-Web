import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import '../../../data/style.dart';
import '../../../data/utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
          body: StreamBuilder(
            stream: controller.internetConnectionState.stream,
            initialData: ConnectivityResult.none, 
            
            builder: (context,AsyncSnapshot<ConnectivityResult> snapshot){
            
              if (snapshot.data == ConnectivityResult.none) {
                // no internet connection
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        40.0), // Adjust the radius as needed
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(20),
                );
              } else {
                // has internet connection
                return InAppWebView(
                  pullToRefreshController: PullToRefreshController(
                      onRefresh: controller.onRefresh,
                      options: PullToRefreshOptions(
                        color: Colors.green,
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
                  onWebViewCreated: (newWebviewController) {
                    controller.webViewController = newWebviewController;
                  },
                  onProgressChanged: (webviewController, progress) {
                    controller.webViewProgress.value = progress;
                  },
                  onLoadStop: (webviewController, url) {
                    controller.currentLoadedUri.value = url;
                  },
                );
              }
            

          }),

        floatingActionButton:  Obx(() => controller.isConnected.value ? FloatingActionButton(onPressed: ()=> controller.goHome(), backgroundColor: AppColor.ACCENT_COLOR, child: const Icon(Icons.home, color: Colors.white,),) : const SizedBox.shrink())
      ),
    );
  }
}
