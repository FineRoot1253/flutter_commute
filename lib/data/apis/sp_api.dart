import 'package:shared_preferences/shared_preferences.dart';

class SPApi {

  Future _completer;
  SharedPreferences _sharedPreferences;

  _createInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return Future.value(0);
  }

  SPApi(){
    if(_sharedPreferences ==null)
      _completer = _createInstance();
  }

  Future get initDone => _completer;


  get userId => _sharedPreferences.get('userId') ?? null;

  Future<void> setUserId(String userId) async {
    await this._sharedPreferences.setString('userId', userId);

    return Future<void>.value();

  }

}