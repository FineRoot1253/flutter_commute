import 'package:commute/UI/widgets/state_panel_widget.dart';
import 'package:commute/data/models/enums.dart';

class UserModel {
  String _userId;
  String _name;
  int _stateNum;
  DateTime _lastUpdatedAt;
  UserState _state;
  StatePanelWidget _statePanelWidget;

  UserModel({String userId, String name, int stateNum, UserState state}) {
    this._userId = userId ?? "undefined";
    this._name = name ?? " ";
    this._stateNum = stateNum ?? 0;
    this._lastUpdatedAt = DateTime.now();
    this._state = state ?? UserState.certificated_beforeWork;
    this._statePanelWidget = StatePanelWidget.fromUserState(this._state);
  }

  String get userId => this._userId;

  String get name => this._name;

  int get stateNum => this._stateNum;

  DateTime get lastUpdateAt => this._lastUpdatedAt;

  UserState get state => this._state;

  StatePanelWidget get statePanelWidget => this._statePanelWidget;

  set stateNum(int val) {
    this._stateNum = val;
  }

  UserModel.fromJson(Map<dynamic, dynamic> record, {UserState state})
      : this._userId = record["userId"] ?? -1,
        this._name = record["userNm"] ?? " ",
        this._stateNum = record["stateNum"] ?? 0,
        this._lastUpdatedAt =
            DateTime.tryParse(record["updatedAt"]).toLocal() ?? DateTime.now(),
        this._state = record["isCommuted"]
            ? UserState.certificated_onWork
            : UserState.certificated_beforeWork,
        this._statePanelWidget = StatePanelWidget.fromUserState(
            record["isCommuted"]
                ? UserState.certificated_onWork
                : UserState.certificated_beforeWork);

  toMap() => {
        "userId": this._userId,
        "userNm": this._name,
        "state": this._stateNum
      };

  @override
  bool operator ==(Object other) {
    return (identical(this, other) ||
        other is UserModel &&
            this.runtimeType == other.runtimeType &&
            this._name == other.name &&
            this._userId == other._userId &&
            this._stateNum == other._stateNum &&
            this._lastUpdatedAt == other._lastUpdatedAt &&
            this._state == other._state &&
            this._statePanelWidget == other._statePanelWidget);
  }

  @override
  int get hashCode =>
      this._userId.hashCode ^
      this._name.hashCode ^
      this._stateNum.hashCode ^
      this._lastUpdatedAt.hashCode ^
      this._state.hashCode ^
      this._statePanelWidget.hashCode;
}
