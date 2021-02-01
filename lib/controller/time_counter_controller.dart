import 'package:get/get.dart';

class TimeCounterController extends GetxController{

  static TimeCounterController get to => Get.find();

  bool _isCommuted = false;

  startTimer() async {
    while(this._isCommuted){
      await Future.delayed(Duration(seconds: 1));
      update();
    }
  }

  String calculateTimeDiff(DateTime time) {
    Duration diff = DateTime.now().difference(time);
    return durationParseToString(diff) + "경과";
  }

  String durationParseToString(Duration date){
    return "${date.inHours} : ${date.inMinutes.remainder(60)} : ${date.inSeconds.remainder(60)} 초 ";
  }

  set toggle(bool isCommuted){this._isCommuted=isCommuted;}

}