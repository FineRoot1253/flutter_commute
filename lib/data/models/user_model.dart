import 'package:commute/UI/widgets/widget.dart';
import 'package:commute/data/models/model.dart';

class UserModel {
  String _userId;
  String _name;
  bool _isCommuted;
  DateTime _onWorkTime;
  DateTime _offWorkTime;
  UserState _state;
  UserWOOModel _wooModel;
  StatePanelWidget _statePanelWidget;

  UserModel({String userId, String name, UserState state, bool isCommuted}) {
    this._userId = userId ?? "undefined";
    this._name = name ?? " ";
    this._onWorkTime = DateTime.now();
    this._offWorkTime = DateTime.now();
    this._isCommuted = isCommuted ?? false;
    this._state = state ?? UserState.certificated_beforeWork;
    this._statePanelWidget = StatePanelWidget.fromUserState(this._state.index);

  }

  String get userId => this._userId;

  String get name => this._name;

  bool get isCommuted => this._isCommuted;

  DateTime get onWorkTime => this._onWorkTime;

  DateTime get offWorkTime => this._offWorkTime;

  UserState get state => this._state;

  StatePanelWidget get statePanelWidget => this._statePanelWidget;

  UserWOOModel get wooModel => this._wooModel;

  set isCommuted(bool isCommuted){this._isCommuted=isCommuted;}
  set state(UserState state){this._state = state;}
  set onWorkTime(DateTime dateTime){this._onWorkTime = dateTime;}
  set offWorkTime(DateTime dateTime){this._offWorkTime = dateTime;}


  UserModel.fromJson(Map<dynamic, dynamic> record)
      : this._userId = record["userId"] ?? -1,
        this._name = record["userNm"] ?? " ",
        this._onWorkTime =
            DateTime.tryParse(record["onWorkTime"]).toLocal() ?? DateTime.now(),
        this._offWorkTime =
            DateTime.tryParse(record["offWorkTime"]).toLocal() ?? DateTime.now(),
        this._state = UserState.values.firstWhere((e)=> e.index == record["state"]),
        this._isCommuted = record["state"] == null ? false : record["state"]>5 ? true : false,
        this._statePanelWidget = StatePanelWidget.fromUserState(record["state"]);

  defineState(int index){
    switch(index){
     case 5:
       return UserState.certificated_beforeWork;
       break;
   case 6:
     return UserState.certificated_onWork;
       break;
   case 7:
     return UserState.certificated_workOnOutside;
       break;

    }
  }


  toMap() => {
        "userId": this._userId,
        "userNm": this._name,
        "state": this._state.index.toString(),
        "onWorkTime": this._onWorkTime.toString(),
        "offWorkTime": this._offWorkTime.toString()
      };


  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
        other is UserModel &&
            this.runtimeType == other.runtimeType &&
            this._name == other.name &&
            this._userId == other._userId &&
            this._offWorkTime == other._offWorkTime &&
            this._onWorkTime == other._onWorkTime &&
            this._state == other._state &&
            this._statePanelWidget == other._statePanelWidget);
  }

  @override
  int get hashCode =>
      this._userId.hashCode ^
      this._name.hashCode ^
      this._onWorkTime.hashCode ^
      this._offWorkTime.hashCode ^
      this._state.hashCode ^
      this._statePanelWidget.hashCode;
}
