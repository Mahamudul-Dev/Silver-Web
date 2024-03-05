import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:silver_view/app/data/utils.dart';

class HomeController extends GetxController {
  Rx<Uri?> currentLoadedUri = Rx<Uri?>(Uri.parse(URL));
  static RxBool isConnected = false.obs;
  InAppWebViewController? webViewController;
  RxInt webViewProgress = 0.obs;
  RxBool isLoading = false.obs;

  // StreamController<ConnectivityResult> internetConnectionState = StreamController<ConnectivityResult>();

  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    webViewController?.reload();
  }

  Future<void> goHome() async {
    await webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse(URL), // Replace with your desired URL
      ),
    );
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
