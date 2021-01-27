import 'package:commute/UI/main_screen.dart';
import 'package:commute/UI/register_screen.dart';
import 'package:commute/bindings/main_binding.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/repository/user_repository.dart';
import 'package:commute/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/a_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SPApi spApi = SPApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LC',
      initialBinding: MainBinding(),
      getPages: routes,
      home: FutureBuilder(
        future: spApi.initDone,
        builder: (context, snapshot1) {
          print(snapshot1.hasData);
          if (snapshot1.hasData)
            return (spApi.userId == null)
                ? RegisterScreen()
                : FutureBuilder(
                    future: AController.to.checkUserRegistration(spApi.userId),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) return MainScreen();
                      if (snapshot2.hasError) {
                        String errStr = snapshot2.error.toString();
                        if (errStr.endsWith("Not Found")) return RegisterScreen();
                        else
                          return Center(
                            child:
                                Text("Error! \n${snapshot2.error.toString()}"),
                          );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
          if (snapshot1.hasError)
            return Center(
              child: Text("Error! \n${snapshot1.error.toString()}"),
            );
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
