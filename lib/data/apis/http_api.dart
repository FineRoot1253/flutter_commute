import 'dart:ffi';

import 'package:commute/data/models/user_model.dart';
import 'package:commute/url/url.dart';
import 'package:http/http.dart' as http;

class HttpApi{

  String _url = URL;

  HttpApi(this._url);

  Future get(String userId, [String path = ""]) async {
   var res = await http.get(this._url+"/$path/$userId");

   return (res.statusCode == 404 || res.statusCode == 500) ?
        "error :\n${res.body}" :
        res.body;
  }

  Future post(UserModel userModel) async {
    var res = await http.post(this._url, body: userModel.toMap());

    return (res.statusCode == 500) ?
      "error :\n${res.statusCode}" :
      Future.value(0);
  }

  Future put(UserModel userModel) async {
    var res = await http.put(this._url+"/user/${userModel.userId}", body: userModel.toMap());

    return (res.statusCode == 500) ?
    "error :\n${res.statusCode}" :
      res.body;

  }

  Future delete(UserModel userModel) async {
    var res = await http.delete(this._url+"/user/${userModel.userId}");

    return (res.statusCode == 500) ?
      "errer :\n${res.statusCode}" :
    Future.value(0);
  }

  Future getPublicIp() async {

    var res = await http.get('https://api.ipify.org');
    return handleResponses(res);

  }

  set url(String url){this._url=url;}

  dynamic handleResponses(http.Response response){

    switch(response.statusCode){
      case 200:
        return response.body;
        break;
      case 404:
        return 404;
      case 500:
        return 500;
        break;
    }
  }

}
