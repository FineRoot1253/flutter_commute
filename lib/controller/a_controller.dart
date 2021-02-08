import 'dart:async';
import 'dart:convert';

import 'package:commute/UI/main_screen.dart';
import 'package:commute/common/ip.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:commute/data/models/user_workOnOutside_model.dart';
import 'package:commute/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AController extends GetxController{

  final UserRepository userRepository;
  UserModel _user;
  UserWOOModel _wooModel;
  final SPApi spApi = SPApi();

  AController({@required this.userRepository}) : assert(userRepository != null);

  static AController get to => Get.find<AController>();

  final TextEditingController registerFormController = TextEditingController();
  List<bool> _toggleList = [true, false];

  UserModel get user => this._user;
  UserWOOModel get wooModel => this._wooModel;
  List<bool> get toggleList => this._toggleList;
  set toggleList(List<bool> list){this._toggleList=list;}

  Future init() async {
    if(!(await checkUserNetwork())) return Future.value(1);
    if(!(await checkUserId()))return Future.value(1);
    return Future.value(0);
  }

  setUser(){
    final String userId = Uuid().v4();
    this._user = UserModel(userId: userId, name: registerFormController.text);
  }

  registerUser() async {
    await userRepository.registerUserdata(this._user);
  }

  checkUserRegistration(String userId) async {
    print("3) 유저 체크 체크 체크");
    this._user = await userRepository.searchUserdata(userId);

    return Future<void>.value();
  }

  updateUserData() async {

    var res = await userRepository.updateUserdata(this._user);

    print(res.body);

    this._user = UserModel.fromJson(jsonDecode(res.body));

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

    print("1) 네트워크 체크 : ${res.body}");
    if(res.body.toString()!=NEWZEN_PUBLIC_IP) {
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

      print("4) 유저 외근 체크");
      if(this._user.state==UserState.certificated_workOnOutside)
        await checkUserWorkTimeWhileOutside();


      return Future.value(true);
    }
  }

  checkUserWorkTimeWhileOutside() async {
    if(this._user.state == UserState.certificated_workOnOutside)
      this._wooModel = await this.userRepository.getUserWorkOnOutsideData(this._user.userId);
  }

  setUserWorkTimeWhileOutside() async {
    if(this._user.state == UserState.certificated_workOnOutside) await this.userRepository.setUserWorkOnOutsideData(this._wooModel);
  }

  updateUserWorkTimeWhileOutside() async {
    if(this._user.state == UserState.certificated_workOnOutside) await this.userRepository.updateUserWorkOnOutsideData(this._wooModel);
  }

}