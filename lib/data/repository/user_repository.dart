import 'dart:convert';
import 'dart:io';

import 'package:commute/data/apis/http_api.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:commute/data/models/user_workOnOutside_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class UserRepository {
  final HttpApi httpApi;

  UserRepository({@required this.httpApi}) : assert(httpApi != null);

  Future registerUserdata(UserModel user) async {
    final spapi = SPApi();
    await spapi.initDone;
    await spapi.setUserId(user.userId);

    String result = handleResponses(await httpApi.post(user));

    if(result.startsWith('error'))
      throw HttpException(result);
    else
      return Future.value(0);

  }

  /// TODO 예외처리는 이곳에서 해 줄 것! 예시는 아래 코드

  Future searchUserdata(String userId) async {
    String result = handleResponses(await httpApi.get(userId, 'user'));

    try{
      if (result.startsWith("Error") || result.startsWith("error"))
        return UserModel(userId: userId, state: UserState.register_required);
      else
        return UserModel.fromJson(jsonDecode(result));
    }catch(e,s){
      print(e);
      print(s);
    }
  }

  Future updateUserdata(UserModel user) async => await httpApi.put(user);

  Future getPublicIp() async => await httpApi.getPublicIp();

  Future getUserWorkOnOutsideData(String userId) async {
    String res = handleResponses(await httpApi.get(userId, 'outside'));

    if (res.startsWith("error"))
      return UserWOOModel(userId: userId);
    else
      return UserWOOModel.fromJson(jsonDecode(res));
  }

  Future setUserWorkOnOutsideData(UserWOOModel wooModel) async {
    String result = handleResponses(await httpApi.post(wooModel,'outside'));

    if(result.startsWith("error"))
      throw HttpException(result);
    else
      return Future.value(0);
  }

  Future updateUserWorkOnOutsideData(UserWOOModel wooModel) async {
    String res1 = handleResponses(await httpApi.put(wooModel,"outside"));

    if(res1.startsWith('error'))
      throw HttpException(res1);
    else
      return Future.value(0);
  }

  dynamic handleResponses(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
        break;
      case 404:
        return 'error : User Not Found';
      case 500:
        return 'error : Unexpected Error';
        break;
    }
  }

}
