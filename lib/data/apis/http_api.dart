import 'package:commute/data/models/user_model.dart';
import 'package:commute/url/url.dart';
import 'package:http/http.dart' as http;

class HttpApi{

  String _url = URL;

  HttpApi(this._url);

  Future get(String userId) async {
   var res = await http.get(this._url+"/user/$userId");

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
    return res.body;

  }

  set url(String url){this._url=url;}

}