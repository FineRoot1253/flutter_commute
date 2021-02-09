import 'dart:io';

import 'package:commute/UI/main_screen.dart';
import 'package:commute/bindings/bindings.dart';
import 'package:commute/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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


