import 'dart:convert';

import 'package:commute/data/apis/http_api.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {
  final HttpApi httpApi;

  UserRepository({@required this.httpApi}) : assert(httpApi != null);

  Future registerUserdata(UserModel user) async {
    final spapi = SPApi();
    await spapi.initDone;
    await spapi.setUserId(user.userId);

    return await httpApi.post(user);
  }

  /// TODO 예외처리는 이곳에서 해 줄 것! 예시는 아래 코드

  Future searchUserdata(String userId) async {
    String result = await httpApi.get(userId, 'user');

    if (result.startsWith("Error") || result.startsWith("error"))
      return UserModel(userId: userId, state: UserState.register_required);
    else
      return UserModel.fromJson(jsonDecode(result));
  }

  Future updateUserdata(UserModel user) async => await httpApi.put(user);

  Future getPublicIp() async => await httpApi.getPublicIp();

  Future getUserWorkOnOutsideData(String userId) async => await httpApi.get(userId, '');
}
