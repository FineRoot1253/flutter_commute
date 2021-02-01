import 'dart:async';
import 'dart:convert';

import 'package:commute/UI/main_screen.dart';
import 'package:commute/common/ip.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:commute/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AController extends GetxController{

  final UserRepository userRepository;
  UserModel _user;
  final SPApi spApi = SPApi();

  AController({@required this.userRepository}) : assert(userRepository != null);

  static AController get to => Get.find<AController>();

  final TextEditingController registerFormController = TextEditingController();
  List<bool> _toggleList = [true, false];

  UserModel get user => this._user;
  List<bool> get toggleList => this._toggleList;
  set toggleList(List<bool> list){this._toggleList=list;}

  Future init() async {
    // this._user = UserModel(state: UserState.waiting_request);
    if(!(await checkUserNetwork())) return Future.value(1);
    if(!(await checkUserId()))return Future.value(1);
    return Future.value(0);
  }

  setUser(){
    final String userId = Uuid().v4();
    this._user = UserModel(userId: userId, name: registerFormController.text, isCommuted: true);

  }

  registerUser() async {
    await userRepository.registerUserdata(this._user);
  }

  checkUserRegistration(String userId) async {
    String result = await userRepository.searchUserdata(userId);
    print("3) 유저 체크 체크 체크");
    if(result.startsWith("Error")||result.startsWith("error"))
      this._user = UserModel(userId : userId, state: UserState.register_required);
    else
      this._user = UserModel.fromJson(jsonDecode(result));

    return Future<void>.value();
  }

  updateUserData() async {

    var res = await userRepository.updateUserdata(this._user);

    print(res);

    this._user = UserModel.fromJson(jsonDecode(res));

    return Future<void>.value();
  }

  String calculateTimeDiff() {
    Duration diff = DateTime.now().difference(this._user.lastUpdateAt.toUtc());
    return durationParseToString(diff) + "경과";
  }

  String durationParseToString(Duration date){
    return "${date.inHours} : ${date.inMinutes.remainder(60)} : ${date.inSeconds.remainder(60)} 초 ";
  }

  String dateTimeParseToString(DateTime date){
    return DateFormat('y-MM-dd hh:mm:ss a').format(date);
  }



  checkUserNetwork() async {
    var res = await userRepository.getPublicIp();

    print("1) 네트워크 체크 : $res");
    if(res.toString()!=NEWZEN_PUBLIC_IP) {
      print("1) 네트워크 체크 not ok");
      this._user = UserModel(state: UserState.network_required);

      return Future.value(false);
    }else{
      print("1) 네트워크 체크 ok");

      return Future.value(true);
    }
  }
  checkUserId() async {
    await spApi.initDone;
    print("2) 유저 체크 체크");

    if(spApi.userId==null){
      print("2) 유저 체크 체크 not ok");
      this._user = UserModel(state: UserState.register_required);

      return Future.value(false);

    }else{
      print("2) 유저 체크 체크 ok");
      await this.checkUserRegistration(spApi.userId);
      return Future.value(true);

    }
  }

}