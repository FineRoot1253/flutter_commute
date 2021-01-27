import 'package:uuid/uuid.dart';

class UserModel {

  String _userId;
  String _name;
  bool _isCommuted;
  DateTime _lastUpdatedAt;

  UserModel({String userId, String name, bool isCommuted}){
    this._userId = userId ?? Uuid().v4();
    this._name = name ?? " ";
    this._isCommuted = isCommuted ?? false;
    this._lastUpdatedAt = DateTime.now();
  }

  String get userId => this._userId;
  String get name => this._name;
  bool get isCommuted => this._isCommuted;
  DateTime get lastUpdateAt => this._lastUpdatedAt;

  set isCommuted(bool val){this._isCommuted = val;}

  UserModel.fromJson(Map<dynamic, dynamic> record) :
    this._userId = record["userId"] ?? -1,
    this._name = record["userNm"] ?? " ",
    this._isCommuted = record["isCommuted"] ?? false,
    this._lastUpdatedAt = DateTime.now();

  toMap() =>
    {"userId":this._userId,
    "userNm":this._name,
      "isCommuted":this._isCommuted.toString()};

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (identical(this, other) ||
            other is UserModel &&
            this.runtimeType == other.runtimeType &&
            this._name == other.name &&
            this._userId == other._userId &&
            this._isCommuted == other._isCommuted);
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
      this._userId.hashCode ^
      this._name.hashCode ^
      this._isCommuted.hashCode;

}