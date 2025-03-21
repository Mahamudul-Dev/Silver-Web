import 'dart:async';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:ape_store/app/data/config.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  Rx<WebUri?> currentLoadedUri = Rx<WebUri?>(WebUri(AppConfig.URL));
  static RxBool isConnected = false.obs;
  InAppWebViewController? webViewController;
  RxInt webViewProgress = 0.obs;
  RxBool isLoading = false.obs;

  // StreamController<ConnectivityResult> internetConnectionState = StreamController<ConnectivityResult>();

  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    if(Platform.isAndroid){
    await webViewController?.reload().then((value) => isLoading.value = false);
    } else if(Platform.isIOS){
      await webViewController?.loadUrl(urlRequest: URLRequest(url: currentLoadedUri.value)).then((value) => isLoading.value = false);
    }
  }

  Future<void> goHome() async {
    await webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(AppConfig.URL), // Replace with your desired URL
      ),
    );
  }

  Future<void> reload() async {
    isLoading.value = true;
    if(Platform.isAndroid){
    await webViewController?.reload().then((value) => isLoading.value = false);
    } else if(Platform.isIOS){
      await webViewController?.loadUrl(urlRequest: URLRequest(url: currentLoadedUri.value)).then((value) => isLoading.value = false);
    }
  }


  Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isDenied || status.isPermanentlyDenied) {
    openAppSettings(); // Open settings if the user denied permanently
  }
}

@override
  void onReady() {
    requestLocationPermission();
    super.onReady();
  }

  @override
  void onClose() {
    currentLoadedUri.close();
    isConnected.close();
    webViewProgress.close();
    super.onClose();
  }

  @override
  void dispose() {
    currentLoadedUri.close();
    isConnected.close();
    webViewProgress.close();
    super.dispose();
  }
}
