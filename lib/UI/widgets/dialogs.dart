import 'package:commute/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

Future distanceCheck() async {
  return AController.to.distanceCheck().then((value) => value
      ? Get.defaultDialog(
          title: "위치 확인", content: Text("확인 완료"), onConfirm: () => Get.back())
      : Get.defaultDialog(
    barrierDismissible: false,
          title: "경고", content: Text("근무지로 복귀 하십시오"), onConfirm: () async =>{
          AController.to.logOutOfRanged().then((value) => Get.back())
  }));
}

Future loadingDialog() async {
  return await Get.dialog(Center(
    child: CircularProgressIndicator(),
  ));
}
