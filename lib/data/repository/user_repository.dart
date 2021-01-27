import 'package:commute/data/apis/http_api.dart';
import 'package:commute/data/apis/sp_api.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserRepository{
  final HttpApi httpApi;

  UserRepository({@required this.httpApi}) : assert(httpApi != null);

  Future registerUserdata(UserModel user) async {
    
    final spapi = SPApi();
    await spapi.initDone;
    await spapi.setUserId(user.userId);
    
    return await httpApi.post(user);
  } 

  Future searchUserdata(String userId) async => await httpApi.get(userId);

  Future updateUserdata(UserModel user) async => await httpApi.put(user);
  

}