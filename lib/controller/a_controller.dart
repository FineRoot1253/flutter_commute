import 'dart:async';
import 'dart:convert';

import 'package:commute/common/coordinates.dart';
import 'package:commute/common/ip.dart';
import 'package:commute/common/keywords.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/Location.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:commute/data/models/user_workOnOutside_model.dart';
import 'package:commute/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Set<Marker> _markerSet = Set<Marker>();
  Set<Circle> _circleSet = Set<Circle>();

  Location _compLocation;
  Location _myLocation;

  UserModel get user => this._user;
  UserWOOModel get wooModel => this._wooModel;
  List<bool> get toggleList => this._toggleList;
  Set<Marker> get markerSet => this._markerSet;
  Set<Circle> get circleSet => this._circleSet;
  Location get compLocation => this._compLocation;
  Location get myLocation => this._myLocation;
  LatLng get compPosition => this._compLocation.marker.position;
  LatLng get myPosition => this._myLocation.marker.position;

  set toggleList(List<bool> list){this._toggleList=list;}

  Future init() async {
    await check();
    await getInitData();
    return Future.value(0);
  }

  setUser(){
    final String userId = Uuid().v4();
    this._user = UserModel(userId: userId, name: registerFormController.text, isCommuted: true);
  }

  registerUser() async {
    await userRepository.registerUserdata(this._user);
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

  check() async {
    if(!(await checkUserLocatePermission())) return Future.value(1);
    if(!(await checkUserRegistered())) return Future.value(1);
    if(!(await checkUserNetwork())) return Future.value(1);
  }

  getInitData() async {
    await getUserLocation();
    await getWooModel();
  }
  /// TODO : 3) 새로운 상태 필드 필요함 => 4) 팩토리에 새로 하나 추가 할 것

  checkUserLocatePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(false);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.value(false);
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.value(false);
      }
    }
    return Future.value(true);
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

  checkUserRegistered() async {
    await spApi.initDone;
    print("2) 유저 체크 체크");

    if (spApi.userId == null) {
      print("2) 유저 체크 체크 not ok");
      this._user = UserModel(state: UserState.register_required);
      return Future.value(false);
    }else{
      print("2) 유저 체크 체크 ok");
      this._user = await userRepository.searchUserdata(spApi.userId);
      return Future.value(true);
    }
  }

  Future getUserLocation() async {
    Position position =  await Geolocator.getCurrentPosition();
    LatLng myLatLng = LatLng(position.latitude, position.longitude);
    LatLng compLatLng = LatLng(DEFAULT_COORDINATES_LAT,DEFAULT_COORDINATES_LNG);
    this._myLocation = Location(latLng: myLatLng, locationId: this._user.userId,title: "내위치",);
    this._compLocation = Location(latLng: compLatLng, locationId: COMP_ID,title: "근무지 위치");
    this._markerSet = {this._compLocation.marker, this._myLocation.marker};
    this._circleSet = {this._compLocation.circle};
  }

  getWooModel() async {
    print("4) 유저 외근 체크");
    if (this._user.state == UserState.certificated_workOnOutside)
      this._wooModel =
      await this.userRepository.getUserWorkOnOutsideData(this._user.userId);
  }

  setUserWorkTimeWhileOutside() async {
    if(this._wooModel==null) this._wooModel = UserWOOModel(userId : this._user.userId, destination: "unknown");
    if(this._user.state == UserState.certificated_workOnOutside) await this.userRepository.setUserWorkOnOutsideData(this._wooModel);
  }

  updateUserWorkTimeWhileOutside() async => await this.userRepository.updateUserWorkOnOutsideData(this._wooModel);

  calculateDistanceDiff() => Geolocator.distanceBetween(this.compPosition.latitude, this.compPosition.longitude, this.myPosition.latitude, this.myPosition.longitude);

  Future distanceCheck() async {
    await getUserLocation();
    return calculateDistanceDiff() <= 150 ? Future.value(true) : Future.value(false);
  }

}