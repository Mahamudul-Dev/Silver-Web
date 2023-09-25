import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  // final flutterWebviewPlugin = FlutterWebviewPlugin();


  // @override
  // void dispose() {
  //   flutterWebviewPlugin.dispose();
  //   super.dispose();
  // }


  InAppWebViewController? webViewController;

  Future<void> onRefresh() async {
    // Reload the WebView page when pulled down to refresh
    webViewController?.reload();
  }

}
