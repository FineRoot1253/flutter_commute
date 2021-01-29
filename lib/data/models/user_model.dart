import 'package:commute/UI/widgets/state_panel_widget.dart';
import 'package:commute/data/models/enums.dart';
import 'package:uuid/uuid.dart';

class UserModel {

  String _userId;
  String _name;
  bool _isCommuted;
  DateTime _lastUpdatedAt;
  UserState _state;
  StatePanelWidget _statePanelWidget;

  UserModel({String userId, String name, bool isCommuted,UserState state}){
    this._userId = userId ?? "undefined";
    this._name = name ?? " ";
    this._isCommuted = isCommuted ?? false;
    this._lastUpdatedAt = DateTime.now();
    this._state = state ?? UserState.certificated_offDuty;
    this._statePanelWidget = StatePanelWidget.fromUserState(this._state);
  }

  String get userId => this._userId;
  String get name => this._name;
  bool get isCommuted => this._isCommuted;
  DateTime get lastUpdateAt => this._lastUpdatedAt;
  UserState get state => this._state;
  StatePanelWidget get statePanelWidget => this._statePanelWidget;

  set isCommuted(bool val){this._isCommuted = val;}

  UserModel.fromJson(Map<dynamic, dynamic> record,{UserState state}) :
    this._userId = record["userId"] ?? -1,
    this._name = record["userNm"] ?? " ",
    this._isCommuted = record["isCommuted"] ?? false,
    this._lastUpdatedAt = DateTime.tryParse(record["updatedAt"]) ?? DateTime.now(),
    this._state = record["isCommuted"] ? UserState.certificated_onDuty : UserState.certificated_offDuty;
  
  toMap() =>
    {"userId":this._userId,
    "userNm":this._name,
      "isCommuted":this._isCommuted.toString()};

  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
            other is UserModel &&
            this.runtimeType == other.runtimeType &&
            this._name == other.name &&
            this._userId == other._userId &&
            this._isCommuted == other._isCommuted &&
            this._lastUpdatedAt == other._lastUpdatedAt &&
            this._state == other._state &&
            this._statePanelWidget == other._statePanelWidget);
  }

  @override
  int get hashCode =>
      this._userId.hashCode ^
      this._name.hashCode ^
      this._isCommuted.hashCode ^
      this._lastUpdatedAt.hashCode ^
      this._state.hashCode ^
      this._statePanelWidget.hashCode;

}