import 'dart:ffi';

import 'package:commute/data/models/user_model.dart';
import 'package:commute/url/url.dart';
import 'package:http/http.dart' as http;

class HttpApi {
  String _url = URL;

  HttpApi(this._url);

  Future get(String userId, [String path = "user"]) async {
    var res = await http.get(this._url + "/$path/$userId");

    return res;
  }

  Future post(dynamic userModel, [String path = "user"]) async {
    print("포스트 : "+userModel.toMap().toString());
    var res = await http.post(this._url+"/$path", body: userModel.toMap());

    return res;
  }

  Future put(dynamic userModel, [String path = "user"]) async {
    var res = await http.put(this._url + "/$path/${userModel.userId}",
        body: userModel.toMap());

    return res;
  }

  Future delete(dynamic userModel) async {
    var res = await http.delete(this._url + "/user/${userModel.userId}");

    return res;
  }

  Future getPublicIp() async {
    var res = await http.get('https://api.ipify.org');
    return res;
  }

  set url(String url) {
    this._url = url;
  }

}



