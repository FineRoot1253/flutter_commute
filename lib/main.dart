import 'dart:io';

import 'package:commute/UI/main_screen.dart';
import 'package:commute/bindings/bindings.dart';
import 'package:commute/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LC',
      initialBinding: MainBinding(),
      getPages: routes,
      home: MainScreen()
    );
  }
}


