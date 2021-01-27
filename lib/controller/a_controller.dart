import 'dart:async';
import 'dart:convert';

import 'package:commute/data/models/user_model.dart';
import 'package:commute/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AController extends GetxController{

  final UserRepository userRepository;
  UserModel _user;

  AController({@required this.userRepository}) : assert(userRepository != null);

  static AController get to => Get.find<AController>();

  final TextEditingController registerFormController = TextEditingController();
  List<bool> _toggleList = [true, false];

  UserModel get user => this._user;
  List<bool> get toggleList => this._toggleList;
  set toggleList(List<bool> list){this._toggleList=list;}

  setUser(){
    final String userId = Uuid().v4();
    this._user = UserModel(userId: userId,name: registerFormController.text, isCommuted: true);
  }

  registerUser() async {
    await userRepository.registerUserdata(this._user);
  }

  checkUserRegistration(String userId) async {
    String result = await userRepository.searchUserdata(userId);
    if(result.startsWith("Error")||result.startsWith("error"))
        throw Exception('Not Found');
    this._user = UserModel.fromJson(jsonDecode(result));
    return this._user;
  }

  updateUserData() async {
    var res = await userRepository.updateUserdata(this._user);
    print(res);
    this._user = UserModel.fromJson(jsonDecode(res));
    return Future<void>.value();
  }

  String calculateTimeDiff() {
    Duration diff = DateTime.now().difference(this._user.lastUpdateAt);
    return durationParseToString(diff) + "경과";
  }

  String durationParseToString(Duration date){
    return "${date.inHours} : ${date.inMinutes.remainder(60)} : ${date.inSeconds.remainder(60)} 초 ";
  }

  String dateTimeParseToString(DateTime date){
    return DateFormat('y-MM-d hh:mm:ss a').format(date);
  }

  startTimer() async {
    while(this._user.isCommuted){
      await Future.delayed(Duration(seconds: 1));
      update();
    }
  }

}