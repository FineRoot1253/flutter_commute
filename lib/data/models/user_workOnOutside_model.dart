import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_model.dart';

class UserWOOModel {
  String _userId;
  String _destination;
  DateTime _createdAt; // 외근 시작 시간
  DateTime _updatedAt; // 외근 복귀 시간

  UserWOOModel(
      {String userId,
      String destination,
      DateTime createdAt,
      DateTime updatedAt}) {
    this._userId = userId ?? "unknown";
    this._destination = destination ?? "unknown";
    this._createdAt = createdAt ?? DateTime.now();
    this._updatedAt = updatedAt ?? DateTime.now();
  }

  UserWOOModel.fromJson(Map<dynamic, dynamic> record)
      : this._userId = record['userId'] ?? "unknown",
        this._destination = record['dest'] ?? "unknown",
        this._createdAt = record['createdAt'] ?? DateTime.now(),
        this._updatedAt = record['updatedAt'] ?? DateTime.now();

  String get userId => this._userId;

  String get destination => this._destination;

  DateTime get createdAt => this._createdAt;

  DateTime get updateAt => this._updatedAt;

  toMap() => {"userId": this._userId, "dest": this._destination};

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (identical(this, other) ||
        other is UserWOOModel &&
            this.runtimeType == other.runtimeType &&
            this._userId == other._userId &&
            this._destination == other._destination &&
            this._createdAt == other._createdAt &&
            this._updatedAt == other._updatedAt);
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
      this._userId.hashCode ^
      this._destination.hashCode ^
      this._createdAt.hashCode ^
      this._updatedAt.hashCode;
}
