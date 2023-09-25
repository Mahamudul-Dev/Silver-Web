import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:silver_view/app/data/utils.dart';

class HomeController extends GetxController {
  Rx<Uri?> currentLoadedUri = Rx<Uri?>(Uri.parse(URL));
  RxBool isConnected = false.obs;
  InAppWebViewController? webViewController;

  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    webViewController?.reload();
  }

  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
    super.onInit();
  }
}
